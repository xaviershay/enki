require File.dirname(__FILE__) + '/../../spec_helper'

# This is under-specced because I anticipate changing this controller 
# substantially quite soon
describe Admin::TagsController do
  describe 'handling GET to index' do
    before(:each) do
      @tags = [mock_model(Tag), mock_model(Tag)]
      Tag.stub!(:paginate).and_return(@tags)
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      response.should be_success
    end

    it "renders index template" do
      response.should render_template('index')
    end
  end
end
