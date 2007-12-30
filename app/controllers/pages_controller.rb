class PagesController < ApplicationController
  make_resourceful do
    actions :show
  end

  protected

  def current_object
    @current_object ||= current_model.find_by_slug(params[:id])
  end
end
