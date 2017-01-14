class ProjectController < ApplicationController
  require 'roo'

  def index
    @projects = Project.all
  end

  def calculate
    redirect_link = '/project/' + params[:project_id]
    session[:info] = params
    respond_to do |format|
      format.html { redirect_to redirect_link }
    end 
  end

  def show
    GC::Profiler.enable
    GC::Profiler.clear
    start_time = Time.now
    @info = session[:info]
    #Handle "fresh" projects that don't have any parameters chosen yet
    if @info == nil
      @info = Hash.new
    end

    #General housekeeping
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name
    @full_project_name = @project_id.to_s + ": " + project_name

    #Load the data into memory
    #file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    #raw_data = CSV.read(file_path, col_sep: ',', converters: :numeric, headers:true)


    #Build the filters for the project
    @filters = Filter.where(:project_id => @project_id, :filter => true)
    @filter_groups = Hash.new
    @filters.pluck(:group).uniq.each do |filter_group|
      filter_list = []
      @filters.where(:group => filter_group).each do |filter_item|
        filter_list << [filter_item.label, filter_item.filter_val, filter_item.var]
      end
      @filter_groups[filter_group] = filter_list
      #puts @filter_groups[filter_group].inspect
    end

    #Build the banners for the project
    @banners = Filter.where(:project_id => @project_id, :banner => true)
    @banner_groups = Hash.new
    @banners.pluck(:group).uniq.each do |banner_group|
      banner_list = []
      @banners.where(:group => banner_group).each do |banner_item|
        banner_list << [banner_item.label, banner_item.filter_val, banner_item.var]
      end
      @banner_groups[banner_group] = banner_list 
    end
    puts 'THESE ARE THE BANNER GROUPS: '
    puts @banner_groups.inspect

    #Build the Metrics for the project
    @metrics = Metric.where(:project_id => @project_id)
    @metric_groups = Hash.new
    @metrics.pluck(:bucket).uniq.each do |metric_group|
      metric_list = []
      @metrics.where(:bucket => metric_group).each do |metric_item|
        metric = Hash.new()
        metric[:label] = metric_item.label
        metric[:var] = metric_item.var
        metric_list << metric
      end
      @metric_groups[metric_group] = metric_list
    end

    mid_time = Time.now
    #Filter the data to match the filter context
    raw_data = Response.where(:project_id => @project_id)
    resp_list = raw_data.pluck(:respondent_id).uniq
    puts 'UNFILTERED RECORD COUNT: ' + raw_data.count.to_s
    puts 'UNFILTERED RESPONDENT COUNT: ' + resp_list.count.to_s

    @filters.pluck(:group).uniq.each do |filter_group|
      if @info.has_key? (filter_group)

        puts 'NOW CHECKING FILTER FOR: ' + filter_group

        filter_info = @info[filter_group].split(',')
        filter_val = nil
        filter_var = nil
        filter_var = filter_info[0]
        filter_val = filter_info[1]

        puts 'FILTER SETTING: ' + filter_info.inspect

        if filter_val != nil
          puts 'NOW APPLYING FILTER FOR: ' + filter_group
          resp_list = raw_data.where(:var => filter_var, :response => filter_val, :respondent_id => resp_list).pluck(:respondent_id).uniq
          puts 'PEEP COUNT: ' + resp_list.count.to_s
        else
          #puts filter_group + ' FILTER does NOT have VALUE: ' + filter_info.inspect
        end
      end
    end

    filtered_data = raw_data.where(:respondent_id => resp_list)

    puts 'FINAL PEEP COUNT: ' + resp_list.count.to_s
    puts 'FINAL RECORD COUNT: ' + filtered_data.count.to_s
    puts @info.inspect
    time_update = Time.now - mid_time
    puts 'TIME ELAPSED FOR RESPONDENT QUERIES: ' + "#{time_update}"


    weight_var = 'Weight_Completes'
    puts @banner_groups[@info[:banner]].inspect

    #Perform calculations
    #Iterate over each metric_item in each metric_group
    counter = 0

    # Go through each banner point (including 'All')
    unstructured_data = Hash.new

    if @info[:banner] == nil
      @info[:banner] = @banner_groups.first[0]
    end


    mid_time = Time.now
    @banner_groups[@info[:banner]].each do |banner_point|
      ban_label = banner_point[0] 
      ban_val = banner_point[1] 
      ban_var = banner_point[2]
      
      unstructured_data[ban_label] = Hash.new
      
      puts 'CHECKING RESPONDENTS: ' + "#{ban_label}"
      if ban_val == nil
        subgroup_filtered_data = filtered_data
      else
        resp_list = filtered_data.where(:var => ban_var, :response => ban_val).pluck(:respondent_id).uniq
        subgroup_filtered_data = filtered_data.where(:respondent_id => resp_list)
      end
      puts 'FOUND RESPONDENTS: ' + "#{ban_label}"
      #unstructured_data[ban_var]

      puts 'UNWEIGHTED BASE: ' + "#{ban_label}"
      unstructured_data[ban_label][:unweighted_base] = subgroup_filtered_data.group(:var).count
      
      puts 'UNWEIGHTED FREQ: ' + "#{ban_label}"
      unstructured_data[ban_label][:unweighted_freq] = subgroup_filtered_data.group(:var).where.not(:response => 0).count
      
      puts 'WEIGHTED BASE: ' + "#{ban_label}"
      unstructured_data[ban_label][:weighted_base] = subgroup_filtered_data.group(:var).sum(:weight)
      
      puts 'WEIGHTED FREQ: ' + "#{ban_label}"
      unstructured_data[ban_label][:weighted_freq] = subgroup_filtered_data.group(:var).where.not(:response => 0).sum('weight * response')
    end
    time_update = Time.now - mid_time
    puts 'TIME ELAPSED FOR MAIN QUERIES: ' + "#{time_update}"

    # unstructured_data.each do |data|
    #   puts 'LOOK HERE'
    #   puts data.inspect
    # end

    @metric_groups.each do |key, value|
      @metric_groups[key].each do |metric_item|
        max_val = 0
        min_val = 100
        @banner_groups[@info[:banner]].each do |banner_point|
          ban_label = banner_point[0]
          ban_var = banner_point[2]
          metric_item[ban_label] = Hash.new
          metric_ban = metric_item[ban_label]
          metric_ban[:unweighted_base] = unstructured_data[ban_label][:unweighted_base][metric_item[:var]]
          metric_ban[:weighted_base] = unstructured_data[ban_label][:weighted_base][metric_item[:var]]
          metric_ban[:unweighted_freq] = unstructured_data[ban_label][:unweighted_freq][metric_item[:var]]
          metric_ban[:weighted_freq] = unstructured_data[ban_label][:weighted_freq][metric_item[:var]]
          if metric_ban[:unweighted_base] != 0 && metric_ban[:unweighted_base] != nil
            if metric_ban[:weighted_freq] == nil
              metric_ban[:full_percent] = 0
              metric_ban[:percent] = 0
            else
              metric_ban[:full_percent] = (metric_ban[:weighted_freq].to_f / metric_ban[:weighted_base].to_f) * 100
              metric_ban[:percent] = metric_ban[:full_percent].round(0)
            end

            if metric_ban[:full_percent] > max_val
                max_val = metric_ban[:full_percent]
              end
              if metric_ban[:full_percent] < min_val
                min_val = metric_ban[:full_percent]
              end
            end
        end
        metric_item[:full_range] = max_val - min_val
        metric_item[:range] = metric_item[:full_range].round(0)
        if metric_item[:full_range] < 0
          metric_item[:full_range] = '-'
          metric_item[:range] = '-'
        end
      end
    end
    #puts 'HERE ARE THE METRIC GROUPS:'
    #puts @metric_groups.inspect
    # puts @metric_groups['Segment Classification'][0]['All Countries'].inspect
    # puts @metric_groups['Segment Classification'][0]['United States'].inspect

    end_time = Time.now
    @time = end_time - start_time
    #GC::Profiler.report
    respond_to do |format|
      format.html
      format.js
    end 

  end

  def show_old
    # file = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    # ws = open_spreadsheet(file)
    start_time = Time.now
    # header = ws.row(1)
    # @header = header.split(',')
    # puts @header.length
    # puts @header
    # ws.default_sheet = ws.sheets.first 
    # @info = []
    # @cols = []
    # last_row = ws.last_row

    # (2..last_row).each do |r|
    #   @info.push(ws.row(r))
    # end
    # last_col = ws.last_column

    # puts last_row
    # puts last_col

    #puts @rows
    end_time = Time.now
    @time = end_time - start_time
  end

  def open_spreadsheet(file)
    puts file
    case File.extname(file)
      when ".csv" then Roo::CSV.new(file, csv_options: {encoding: Encoding::ISO_8859_1})
      when ".xls" then Roo::Excel.new(file, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end  
  end

  def sum
      self.inject{|sum,x| sum + x }
  end
end