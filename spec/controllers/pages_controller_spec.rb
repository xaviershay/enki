require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe 'handling GET for a single post' do
    before(:each) do
      @page = mock_model(Page)
      allow(Page).to receive(:find_by_slug).and_return(@page)
    end

    def do_get
      get :show, :id => 'a-page'
    end

    it "should be successful" do
      do_get
      expect(response).to be_success
    end

    it "should render show template" do
      do_get
      expect(response).to render_template('show')
    end

    it 'should find the page requested' do
      expect(Page).to receive(:find_by_slug).with('a-page').and_return(@page)
      do_get
    end

    it 'should assign the page found for the view' do
      do_get
      expect(assigns[:page]).to equal(@page)
    end
  end

  describe 'handling GET with invalid page' do
    it 'raises a RecordNotFound error' do
      allow(Page).to receive(:find_by_slug).and_return(nil)
      expect {
        get :show, :id => 'a-page'
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
