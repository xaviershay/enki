class Admin::ApiController < Admin::BaseController
  layout 'admin_new'

  def show
    @key = salt
  end
end
