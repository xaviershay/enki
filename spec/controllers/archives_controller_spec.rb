require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'handling GET to index' do
    before(:each) do
      month = Struct.new(:date, :posts)
      @months = [month.new(1.month.ago.utc.beginning_of_month, [mock_model(Post)])]
      allow(Post).to receive(:find_all_grouped_by_month).and_return(@months)
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render index template" do
      do_get
      expect(response).to render_template('index')
    end

    it "should assign the found months for the view" do
      do_get
      expect(assigns[:months]).to eq(@months)
    end

    it 'should find posts grouped by month' do
      expect(Post).to receive(:find_all_grouped_by_month).and_return(@months)
      do_get
    end
  end
end
