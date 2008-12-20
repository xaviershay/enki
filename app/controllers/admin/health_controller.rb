class Admin::HealthController < Admin::BaseController
  before_filter :require_login
  verify :method => 'post', :only => 'exception', :render => {:text => 'Method not allowed', :status => 405}, :add_headers => {"Allow" => "POST"}

  def index
  end

  def exception
    raise RuntimeError
  end
end
