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
        if author = Author.with_open_id(response.identity_url)
          session[:author_id] = author.id
          redirect_to(admin_posts_path)
          return
        else
          flash.now[:error] = "You are not authorized"
        end
      end
    rescue HyperOpenID::AuthenticationFailure => e
      flash.now[:error] = "Authentication failed for #{e.identity_url}"
    rescue OpenID::DiscoveryFailure
      flash.now[:error] = "Discovery failed for #{params[:openid_url]}"
    end
    render :action => 'new'
  end

  def destroy
    session[:author_id] = nil
    redirect_to('/')
  end
end
