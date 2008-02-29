require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ApiController do
  describe 'handling GET to show' do
    before(:each) do
      session[:logged_in] = true
      get :show
    end

    it 'assigns key for the view' do
      assigns(:key).should_not be_nil
    end

    it 'is successful' do
      response.should be_success
    end
  end
end
