class Admin::PostsController < ApplicationController
  make_resourceful do
    actions :index, :new, :create, :destroy, :edit, :update
  end
end
