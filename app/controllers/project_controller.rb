class ProjectController < ApplicationController
  require 'roo'

  def index
    @projects = Project.all
  end

  def calculate
    redirect_link = '/project/' + params[:project_id]
    session[:info] = params
    redirect_to redirect_link 
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
    puts @info

    #General housekeeping
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name
    @full_project_name = @project_id.to_s + ": " + project_name

    #Load the data into memory
    file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    raw_data = CSV.read(file_path, col_sep: ',', converters: :numeric, headers:true)


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

    #Filter the data to match the filter context
    filtered_data = Hash.new
    raw_data.each do |resp|
      filtered_data[resp['Respondent_ID']] = resp
    end

    @filters.pluck(:group).uniq.each do |filter_group|
      if @info.has_key? (filter_group)

        puts 'NOW CHECKING FILTER FOR: ' + filter_group

        filter_info = @info[filter_group].split(',')
        filter_val = nil
        filter_var = nil
        filter_var = filter_info[0]
        filter_val = filter_info[1].to_i

        puts 'FILTER SETTING: ' + filter_info.inspect

        if filter_val != nil
          puts 'NOW APPLYING FILTER FOR: ' + filter_group
          filtered_data.each do |key, resp|
            if resp[filter_var] != filter_val
              filtered_data.delete(resp['Respondent_ID'])
            end
          end
          puts 'PEEP COUNT: ' + filtered_data.keys.count.to_s
        else
          #puts filter_group + ' FILTER does NOT have VALUE: ' + filter_info.inspect
        end
      end
    end

    puts 'FINAL PEEP COUNT: ' + filtered_data.keys.count.to_s
    puts @info.inspect


    weight_var = 'Weight_Completes'

    #Perform calculations
    @metric_groups.each do |key, value|
      @metric_groups[key].each do |metric_item|
        metric_item[:weighted_freq] = 0
        metric_item[:unweighted_freq] = 0
        metric_item[:weighted_base] = 0
        metric_item[:unweighted_base] = 0
        metric_item[:percent] = nil
        filtered_data.each do |key, resp|
          # puts resp.inspect
          if resp[metric_item[:var]] != nil
            resp_weight = resp[weight_var]
            if resp[metric_item[:var]] == 1
              metric_item[:weighted_freq] += resp_weight
              metric_item[:unweighted_freq] += 1
            end
            metric_item[:weighted_base] += resp_weight
            metric_item[:unweighted_base] += 1
          end
        end
        if metric_item[:unweighted_base] >0
          metric_item[:percent] = (metric_item[:weighted_freq] / metric_item[:weighted_base]) * 100
        else
          metric_item[:percent] = nil
        end

        puts metric_item.inspect
      end
    end


    end_time = Time.now
    @time = end_time - start_time
    #GC::Profiler.report
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