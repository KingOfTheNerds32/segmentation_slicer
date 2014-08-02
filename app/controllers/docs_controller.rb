class DocsController < ApplicationController
  def upload

  end
  def submit
    counter = 0
    status = "Success"
    book = Spreadsheet.open '/Users/michaellarner/Documents/src/segmentation_slicer/FlatTest.xls'

    # Project.destroy_all()
    # wsProjects = book.worksheet 'Projects'
    # wsProjects.each 1 do |row|
    #   counter = 0
    #   Project.create(project_id:row[0], project_name:row[1])
    #   counter +=1
    # end
    # if counter + 1 != wsProjects.count || status == "Fail"
    #   status = "Fail"
    # end

    # Response.destroy_all()
    # wsResponses = book.worksheet 'Responses'
    # wsResponses.each 1 do |row|
    #   counter = 0
    #   Response.create(respondent_id:row[0], metric_id:row[1], value_id:row[2])
    #   counter+=1
    # end
    # if counter + 1 != wsProjects.count || status == "Fail"
    #   status = "Fail"
    # end

    # Metric.destroy_all
    # wsMetrics = book.worksheet 'Metrics'
    # wsMetrics.each 1 do |row|
    #   counter = 0
    #   Metric.create(project_id:row[0], metric_id:row[1], metric_text:row[2])
    #   counter+=1
    # end
    # if counter + 1 != wsProjects.count || status == "Fail"
    #   status = "Fail"
    # end

    # Filter.destroy_all
    # wsFilters = book.worksheet 'Filters'
    # wsFilters.each 1 do |row|
    #   counter = 0
    #   Filter.create(project_id:row[0], metric_id:row[1], value_id:row[2], value_text:row[3])
    #   counter+=1
    # end
    # if counter + 1 != wsProjects.count || status == "Fail"
    #   status = "Fail"
    # end

    redirect_to '/status/' + status
  end

  def status()
    @status = params[:status]
  end
end