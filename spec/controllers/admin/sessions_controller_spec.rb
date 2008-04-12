require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do
  # TODO: OpenID spec

  describe 'handling GET to show (default)' do
    it 'redirects to new' do
      get :show
      response.should be_redirect
      response.should redirect_to(new_admin_session_path)
    end
  end

  describe 'handling GET to new' do
    before(:each) do
      get :new
    end

    it "should be successful" do
      response.should be_success
    end

    it "should render index template" do
      response.should render_template('new')
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      delete :destroy
    end

    it 'logs out the current session' do
      session[:logged_in].should == false
    end

    it 'redirects to /' do
      response.should be_redirect
      response.should redirect_to('/')
    end
  end
end
