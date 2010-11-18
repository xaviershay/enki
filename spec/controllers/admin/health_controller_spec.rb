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

  describe 'handling POST to generate_exception' do
    describe 'when logged in' do
      it 'raises a RuntimeError' do
        session[:logged_in] = true
        lambda {
          post :generate_exception
        }.should raise_error
      end
    end

    describe 'when not logged in' do
      it 'does not raise' do
        lambda {
          post :generate_exception
        }.should_not raise_error
      end
    end
  end

  describe 'handling GET to generate_exception' do
    it '405s' do
      session[:logged_in] = true
      get :generate_exception
      response.status.should == 405
      response.headers['Allow'].should == 'POST'
    end
  end
end
