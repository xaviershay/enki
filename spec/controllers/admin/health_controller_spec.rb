require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HealthController do
  describe 'handling GET to index' do
    before(:each) do
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      response.should be_success
    end

    it "renders health template" do
      response.should render_template("index")
    end
  end

  describe 'handling POST to exception' do
    describe 'when logged in' do
      it 'raises a RuntimeError' do
        session[:logged_in] = true
        lambda {
          post :exception
        }.should raise_error
      end
    end

    describe 'when not logged in' do
      it 'does no raise' do
        lambda {
          post :exception
        }.should_not raise_error
      end
    end
  end

  describe 'handling GET to exception' do
    it '405s' do
      session[:logged_in] = true
      get :exception
      response.headers['Status'].should == '405 Method Not Allowed'
      response.headers['Allow'].should == 'POST'
    end
  end
end
