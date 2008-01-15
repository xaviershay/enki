require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'handling GET to index' do
    before(:each) do
      month = Struct.new(:date, :posts)
      @months = [month.new(1.month.ago.utc.beginning_of_month, [mock_model(Post)])]
      Post.stub!(:find_all_grouped_by_month).and_return(@months)
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should assign the found months for the view" do
      do_get
      assigns[:months].should == @months
    end

    it 'should find posts grouped by month' do
      Post.should_receive(:find_all_grouped_by_month).and_return(@months)
      do_get
    end
  end
end
