class ProjectController < ApplicationController
  require 'roo'

  def index
    @projects = Project.all
  end

  def calculate
    redirect_link = '/project/' + params[:project_id]
    redirect_to  redirect_link
  end

  def show
    GC::Profiler.enable
    GC::Profiler.clear
    start_time = Time.now

    #General housekeeping
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name
    @full_project_name = @project_id.to_s + ": " + project_name

    puts params.inspect
    puts params['Country']


    #Load the data into memory
    file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    raw_data = CSV.read(file_path, col_sep: '|', converters: :numeric, headers:true)


    #Build the filters for the project
    @filters = Filter.where(:project_id => @project_id)
    @filter_groups = Hash.new
    @filters.pluck(:group).uniq.each do |filter_group|
      filter_list = []
      @filters.where(:group => filter_group).each do |filter_item|
        filter_list << [filter_item.label, filter_item.filter_val]
      end
      @filter_groups[filter_group] = filter_list
      #puts @filter_groups[filter_group].inspect
    end


    #Filter the data to match the filter context
    filtered_data = []
    raw_data.each do |resp|
      if resp['Country'] == 1
        filtered_data << resp
      end
    end

    #puts filtered_data.length

    end_time = Time.now
    @time = end_time - start_time
    GC::Profiler.report
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