ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resource :session

    admin.resources :posts
    admin.resources :pages
  end

  map.connect 'pages/:id', :controller => 'pages', :action => 'show'

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug',         :controller => 'posts', :action => 'show'
  map.connect ':year/:month/:day/:slug.:format', :controller => 'posts', :action => 'show'
  map.connect ':tag', :controller => 'posts', :action => 'index'
  map.connect '', :controller => 'posts', :action => 'index'
end
