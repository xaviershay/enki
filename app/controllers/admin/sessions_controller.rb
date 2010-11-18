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
    return successful_login(Author.find(:first)) if allow_login_bypass? && params[:bypass_login]
    if params[:openid_url].present?
      authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
        if result.successful?
          if author = Author.with_open_id(identity_url)
            return successful_login(author)
          else
            flash.now[:error] = result.message
          end
        else
          flash.now[:error] = "Sorry, the OpenID server couldn't be found"
        end
      end
    else
      flash.now[:error] = "You must supply a URL"
    end
    render :action => 'new'
  end

  def destroy
    session[:author_id] = nil
    redirect_to('/')
  end

protected

  def successful_login(author)
    session[:logged_in] = true
    session[:author_id] = author.id
    redirect_to(admin_root_path)
  end

  def allow_login_bypass?
    %w(development test).include?(Rails.env)
  end
  helper_method :allow_login_bypass?
end
