require "pathname"
require "cgi"

# load the openid library
begin
  require "rubygems"
  require_gem "ruby-openid", ">= 1.0.2"
rescue LoadError
  require "openid"
end

class <%= class_name %>Controller < ApplicationController
  layout  'scaffold'
  
  # process the login request, disover the openid server, and
  # then redirect.
  def login
    openid_url = params[:openid_url]

    if request.post?
      request = consumer.begin(openid_url)

      case request.status
      when OpenID::SUCCESS
        return_to = url_for(:action=> 'complete')
        trust_root = url_for(:controller=>'')

        url = request.redirect_url(trust_root, return_to)
        redirect_to(url)
        return

      when OpenID::FAILURE
        escaped_url = CGI::escape(openid_url)
        flash[:notice] = "Could not find OpenID server for #{escaped_url}"
        
      else
        flash[:notice] = "An unknown error occured."

      end      
    end    

  end

  # handle the openid server response
  def complete
    response = consumer.complete(params)
    
    case response.status
    when OpenID::SUCCESS

      @user = User.get(response.identity_url)
      
      # create user object if one does not exist
      if @user.nil?
        @user = User.new(:openid_url => response.identity_url)
        @user.save
      end

      # storing both the openid_url and user id in the session for for quick
      # access to both bits of information.  Change as needed.
      session[:user_id] = @user.id

      flash[:notice] = "Logged in as #{CGI::escape(response.identity_url)}"
       
      redirect_back_or_default :action => "welcome"
      return

    when OpenID::FAILURE
      if response.identity_url
        flash[:notice] = "Verification of #{response.identity_url} failed."

      else
        flash[:notice] = 'Verification failed.'
      end

    when OpenID::CANCEL
      flash[:notice] = 'Verification cancelled.'

    else
      flash[:notice] = 'Unknown response from OpenID server.'
    end
  
    redirect_to :action => 'login'
  end
  
  def logout
    session[:user_id] = nil
  end
    
  def welcome
  end

  private

  # Get the OpenID::Consumer object.
  def consumer
    # Create the OpenID store for storing associations and nonces,
    # putting it in your app's db directory.
    # Note: see the plugin located at examples/active_record_openid_store 
    # if you need to store this information in your database. 
    store_dir = Pathname.new(RAILS_ROOT).join('db').join('openid-store')
    store = OpenID::FilesystemStore.new(store_dir)

    return OpenID::Consumer.new(session, store)
  end

  # get the logged in user object
  def find_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end
  
end
