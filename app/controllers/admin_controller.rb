class AdminController < ApplicationController

  def admin
    @project_id = params[:project_id]
    project_info = Project.find_by project_id: @project_id
    project_name = project_info.project_name

    @full_project_name = @project_id.to_s + ": " + project_name
  end
  def update
    @project_id = params[:project_id]

    file_path = '/Users/michaellarner/Documents/src/segmentation_slicer/Filters.csv'
    filter_data = CSV.read(file_path, col_sep: '|', converters: :numeric, headers:true)
    current_filters = Filter.where(:project_id => @project_id)
    current_filters.destroy_all

    filter_data.each do |filter|
      filter['project_id'] = @project_id
      Filter.create!(filter.to_hash)
    end

    redirect_link = '/project/' + params[:project_id] + '/admin'
    redirect_to  redirect_link
  end
end
