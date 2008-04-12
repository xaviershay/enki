class Admin::SessionsController < ApplicationController
  layout 'login'

  def show
    if using_open_id?
      create
    else
      redirect_to :action => 'new'
    end
  end

  def new
  end

  def create
    return if authenticate_with_open_id(params[:openid_url]) do |status, identity_url|
      if URI.parse(response.identity_url) == URI.parse(config[:author, :open_id])
        session[:logged_in] = true
        redirect_to(admin_posts_path)
        return
      else
        status.extend(ExposeCode)
        case status.code
        when :missing
          flash.now[:error] = "Sorry, the OpenID server couldn't be found"
        when :canceled
          flash.now[:error] = "OpenID verification was canceled"
        when :failed
          flash.now[:error] = "Sorry, the OpenID verification failed"
        when :successful
          flash.now[:error] = "You are not authorized"
        end
      end
    end
    render :action => 'new'
  end

  def destroy
    session[:logged_in] = false
    redirect_to('/')
  end
end
