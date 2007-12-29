ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :posts
  end

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug',         :controller => 'posts', :action => 'show'
  map.connect ':year/:month/:day/:slug.:format', :controller => 'posts', :action => 'show'
  map.connect '', :controller => 'posts', :action => 'index'
end
