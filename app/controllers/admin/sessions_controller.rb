class Admin::SessionsController < ApplicationController
  layout 'login'

  def show
    if openid_completion?(request)
      create
    else
      redirect :action => 'new'
    end
  end

  def new
  end

  def create
    begin
      return if open_id_authenticate(params[:openid_url]) do |response|
        if response.identity_url == "http://rhnh.net/"
          session[:logged_in] = true
          redirect_to(admin_posts_path)
          return
        else
          flash.now[:error] = "You are not authorized"
        end
      end
    rescue OpenID::AuthenticationFailure => e
      flash.now[:error] = "Authentication failed for #{e.identity_url}"
    rescue OpenID::DiscoveryFailure
      flash.now[:error] = "Discovery failed for #{params[:openid_url]}"
    end
    render :action => 'new'
  end

  def destroy
    session[:logged_in] = false
    redirect_to('/')
  end
end
