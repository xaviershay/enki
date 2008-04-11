require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do
  # TODO: OpenID spec

  describe 'handling GET to show (default)' do
    before(:each) do
      get :show
    end

    it 'redirects to new' do
      pending("get :show doesn't seem to work")
      response.should be_redirect
      response.should redirect_to(:action => 'new')
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
      session[:author_id].should == nil
    end

    it 'redirects to /' do
      response.should be_redirect
      response.should redirect_to('/')
    end
  end
end
