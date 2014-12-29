SegmentationSlicer::Application.routes.draw do
  root 'project#index'
  get '/projects' => 'project#index'
  get '/project/:project_id' => 'project#show'
  get '/project/:project_id/admin' => 'admin#admin'
  post '/project/:project_id/update' => 'admin#update'
  post 'project/:project_id/calculate' => 'project#calculate'
  get '/project/:project_id/metric' => 'admin#metric_download'
  get '/project/:project_id/filter' => 'admin#filter_download'
end
