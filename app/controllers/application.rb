# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  layout 'main'

  after_filter :set_content_type

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery #:secret => 'a6a9e417376364b61645d469f04ac8cf'

  protected

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def open_id_authenticate(url, options = {})
    consumer = OpenID::Consumer.new(session[:openid_session] ||= {}, OpenID::Store::Filesystem.new('tmp/openid'))
    if openid_completion?(request)
      openid_response = consumer.complete(params.reject{|k,v|request.path_parameters[k]}, request.protocol + request.host_with_port + request.request_uri)

      if openid_response.is_a?(OpenID::Consumer::SuccessResponse)
        yield(openid_response)
      else
        raise OpenID::AuthenticationFailure.new(openid_response)
      end
      return false
    else
      openid_request = consumer.begin(url)
      options[:extensions].to_a.each do |extension|
        openid_request.add_extension(extension)
      end

      options[:before_redirect].send_with_default(:call)

      return_path = request.protocol + request.host_with_port + request.request_uri
      redirect(openid_request.redirect_url(request.protocol + request.host_with_port + '/', return_path))
      return true
    end
  end

  def openid_completion?(request)
    request.get? && params["openid.mode"]
  end
    
  def redirect(where = {})
    headers['Location'] = url_for(where)
    render :nothing => true, :status => '302 Redirect'
    return
  end
end
