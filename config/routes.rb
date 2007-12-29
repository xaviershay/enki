ActionController::Routing::Routes.draw do |map|
  map.connect ':year/:month/:date/:slug',         :controller => 'posts', :action => 'show'
  map.connect ':year/:month/:date/:slug.:format', :controller => 'posts', :action => 'show'
  map.connect '', :controller => 'posts', :action => 'index'
end
