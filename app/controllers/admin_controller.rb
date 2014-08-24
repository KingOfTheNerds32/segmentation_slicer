class AdminController < ApplicationController

  def admin
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name

    @full_project_name = @project_id.to_s + ": " + project_name
  end
  def update
    start_time = Time.now
    @project_id = params[:project_id]

    #Update Filter table to contain info for project
    file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/Filters.csv'
    filter_data = CSV.read(file_path, col_sep: ',', converters: :numeric, headers:true)
    current_filters = Filter.where(:project_id => @project_id)
    current_filters.destroy_all

    filter_data.each do |filter|
      filter['project_id'] = @project_id
      puts filter.inspect
      Filter.create!(filter.to_hash)
    end

    #Update Metric table to contain info for project
    file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/Metrics.csv'
    metric_data = CSV.read(file_path, col_sep: '|', converters: :numeric, headers:true)
    current_metrics = Metric.where(:project_id => @project_id)
    current_metrics.destroy_all

    metric_data.each do |metric|
      metric['project_id'] = @project_id
      Metric.create!(metric.to_hash)
    end

    #Update Response table to contain info for project. Limit to non-null & metrics used in the filter and metric tables
    filter_vars = Filter.where(:project_id => @project_id).pluck(:var).uniq
    metric_vars = Metric.where(:project_id => @project_id).pluck(:var).uniq
    dimensions_list = filter_vars + metric_vars
    
    # file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    # response_data = CSV.read(file_path, col_sep: ',', converters: :numeric, headers:true)
    # current_responses = Response.where(:project_id => @project_id)
    # current_responses.destroy_all


    # puts dimensions_list.count
    # response_data.each do |resp|
    #   resp_id = resp['Respondent_ID']
    #   resp_weight = resp['Weight_Completes']
    #   dimensions_list.each do |dimension|
    #     if resp[dimension]
    #       r = Response.new
    #       r.respondent_id = resp_id
    #       r.weight = resp_weight
    #       r.project_id = @project_id
    #       r.var = dimension
    #       r.response = resp[dimension]
    #       r.save
    #     end
    #   end
    # end

    end_time = Time.now
    @time = end_time - start_time
    puts 'Model updated in ' + @time.to_s + ' seconds' 


    redirect_link = '/project/' + params[:project_id] + '/admin'
    redirect_to  redirect_link
  end
end
