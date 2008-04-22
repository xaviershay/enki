class Admin::ApiController < Admin::BaseController
  def show
    @key = salt
  end
end
