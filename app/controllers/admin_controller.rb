class AdminController < ApplicationController

  def admin
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    @project_name = project_info.project_name

    @full_project_name = @project_id.to_s + ": " + @project_name
  end
  def update
    start_time = Time.now
    @project_id = params[:project_id]

    #Update Filter table to contain info for project
    filter_path = params[:filters]
    if filter_path
      puts 'Updating FILTERS with ' + filter_path
      filter_data = CSV.read(filter_path, col_sep: '|', converters: :numeric, headers:true)
      current_filters = Filter.where(:project_id => @project_id)
      current_filters.destroy_all

      filter_data.each do |filter|
        filter['project_id'] = @project_id
        puts filter.inspect
        Filter.create!(filter.to_hash)
      end
    end

    #Update Metric table to contain info for project
    metric_path = params[:metrics]
    if metric_path
      puts 'Updating METRICS with ' + metric_path
      metric_data = CSV.read(metric_path, col_sep: '|', converters: :numeric, headers:true)
      current_metrics = Metric.where(:project_id => @project_id)
      current_metrics.destroy_all

      metric_data.each do |metric|
        metric['project_id'] = @project_id
        Metric.create!(metric.to_hash)
      end
    end

    project_info = Project.find_by project_id: @project_id
    @project_name = params[:name]
    if project_info.project_name != @project_name
      project_info.project_name = @project_name
      project_info.save
      puts 'Changing project name to: ' + @project_name
    end

    # #Update Response table to contain info for project. Limit to non-null & metrics used in the filter and metric tables
    # filter_vars = Filter.where(:project_id => @project_id).pluck(:var).uniq
    # metric_vars = Metric.where(:project_id => @project_id).pluck(:var).uniq
    # dimensions_list = filter_vars + metric_vars

    # file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.csv'
    # response_data = CSV.read(file_path, col_sep: ',', converters: :numeric, headers:true)
    # current_responses = Response.where(:project_id => @project_id)
    # current_responses.destroy_all

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


  def filter_download
    @project_id = params[:project_id]
    @filters = Filter.where(:project_id=> @project_id)
    respond_to do |format|
      format.html
      #format.csv {render text: @metrics.to_csv(col_sep: '|')}
      format.csv {send_data @filters.to_csv(col_sep: '|')}
    end
  end
    def metric_download
    @project_id = params[:project_id]
    @metrics = Metric.where(:project_id=> @project_id)
    respond_to do |format|
      format.html
      #format.csv {render text: @metrics.to_csv(col_sep: '|')}
      format.csv {send_data @metrics.to_csv(col_sep: '|')}
    end
  end
end

