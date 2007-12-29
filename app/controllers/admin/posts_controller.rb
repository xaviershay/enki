class Admin::PostsController < ApplicationController
  layout 'admin'

  make_resourceful do
    actions :index, :new, :create, :edit, :update
  end

  protected

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end
end
