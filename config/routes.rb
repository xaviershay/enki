ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resource :session

    admin.resources :posts
    admin.resources :pages
    admin.resources :comments, :member => {:mark_as_spam => :put, :mark_as_ham => :put}
    admin.resources :tags
    admin.resource :api, :controller => 'api'
  end

  map.connect '/admin', :controller => 'admin/posts', :action => 'index'
  map.connect '/admin/api', :controller => 'admin/api', :action => 'index'
  map.archives '/archives', :controller => 'archives', :action => 'index'

  map.root :controller => 'posts', :action => 'index'
  map.resources :posts

  map.connect 'pages/:id', :controller => 'pages', :action => 'show'

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug/comments/new', :controller => 'comments', :action => 'new'
  map.connect ':year/:month/:day/:slug/comments.:format', :controller => 'comments', :action => 'index'
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show'
  map.posts_with_tag ':tag', :controller => 'posts', :action => 'index'
  map.formatted_posts_with_tag ':tag.:format', :controller => 'posts', :action => 'index'
end
