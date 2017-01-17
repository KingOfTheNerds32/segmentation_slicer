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

    if @info == nil
      @info = Hash.new
    end

    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name
    @full_project_name = @project_id.to_s + ": " + project_name

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

    @banners = Filter.where(:project_id => @project_id, :banner => true)
    @banner_groups = Hash.new
    @banners.pluck(:group).uniq.each do |banner_group|
      banner_list = []
      @banners.where(:group => banner_group).each do |banner_item|
        banner_list << [banner_item.label, banner_item.filter_val, banner_item.var]
      end
      @banner_groups[banner_group] = banner_list 
    end


    @metrics = Metric.where(:project_id => @project_id).pluck(:bucket, :var, :label)
    @metric_groups = Hash.new
    @metrics.each do |metric_item|
      metric = Hash.new()
      metric[:label] = metric_item[2]
      metric[:var] = metric_item[1]
      if @metric_groups.key?(metric_item[0]) == false
        @metric_groups[metric_item[0]] = []
      end
      @metric_groups[metric_item[0]].push(metric)
    end

    mid_time = Time.now
    #Filter the data to match the filter context
    raw_data = Response.where(:project_id => @project_id)
    resp_list = raw_data.pluck(:respondent_id).uniq
    puts 'UNFILTERED RECORD COUNT: ' + raw_data.count.to_s
    puts 'UNFILTERED RESPONDENT COUNT: ' + resp_list.count.to_s

    @filters.pluck(:group).uniq.each do |filter_group|
      if @info.key?(filter_group)

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
