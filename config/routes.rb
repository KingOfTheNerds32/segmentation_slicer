SegmentationSlicer::Application.routes.draw do
  get '/projects' => 'project#index'
  get '/project/:project_id' => 'project#show'
end
