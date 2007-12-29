class Admin::PostsController < ApplicationController
  layout 'admin'

  make_resourceful do
    actions :index, :new, :create
  end
end
