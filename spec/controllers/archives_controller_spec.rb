require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'handling GET to index' do
    let(:months) { double Array }
    
    before(:each) do
      Post.should_receive(:find_all_grouped_by_month).and_return(months)
      get :index
    end

    it "should be successful" do
      response.should be_success
    end

    it "should render index template" do
      response.should render_template(:index)
    end

    it "should assign the found months for the view" do
      assigns[:months].should == months
    end
  end
end
