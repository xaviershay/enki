class Admin::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_authenticity_token_unless_using_open_id, :only => :create

  layout 'login'

  def show
    redirect_to :action => 'new'
  end

  def new
    flash.now[:error] = params[:message] if params[:message] # OmniAuth error message.
  end

  def create
    return successful_login if allow_login_bypass? && params[:bypass_login] == '1'

    if request.env['omniauth.auth'].present?
      case request.env['omniauth.auth'][:provider]
      when OMNIAUTH_GOOGLE_OAUTH2_STRATEGY
        if enki_config.author_google_oauth2_email == request.env['omniauth.auth'][:info][:email]
          save_auth_details(request.env['omniauth.auth'])
          return successful_login
        else
          return show_not_authorized
        end
      when OMNIAUTH_OPEN_ID_ADMIN_STRATEGY
        if enki_config.author_open_ids.include?(URI.parse(request.env['omniauth.auth'][:uid]))
          save_auth_details(request.env['omniauth.auth'])
          return successful_login
        else
          return show_not_authorized
        end
      else
        raise ArgumentError, "The value returned from request.env['omniauth.auth'][:provider] is unknown."
      end
    end

    show_not_authorized
  end

  def destroy
    session[:logged_in] = false
    redirect_to('/')
  end

protected

  def show_not_authorized
    flash.now[:error] = 'You are not authorized'
    render :action => 'new'
  end

  def save_auth_details(auth_response)
    OmniAuthDetails.create(
      :provider =>    auth_response[:provider],
      :uid =>         auth_response[:uid],
      :info =>        auth_response[:info],
      :credentials => auth_response[:credentials],
      :extra =>       auth_response[:extra]
    )
  end

  def successful_login
    session[:logged_in] = true
    redirect_to(admin_root_path)
  end

  def allow_login_bypass?
    %w(development test).include?(Rails.env)
  end

  def verify_authenticity_token_unless_using_open_id
    verify_authenticity_token unless using_open_id?
  end

  def using_open_id?
    if request.env['omniauth.auth'].present?
      if request.env['omniauth.auth'][:provider] == OMNIAUTH_GOOGLE_OAUTH2_STRATEGY ||
         request.env['omniauth.auth'][:provider] == OMNIAUTH_OPEN_ID_ADMIN_STRATEGY
        return true
      end
    end

    return false
  end

  helper_method :allow_login_bypass?
end
