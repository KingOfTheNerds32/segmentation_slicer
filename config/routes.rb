SegmentationSlicer::Application.routes.draw do
  get '/projects' => 'project#index'
  get '/project/:project_id' => 'project#show'
  get '/project/:project_id/admin' => 'admin#admin'
  post '/project/:project_id/update' => 'admin#update'
end
