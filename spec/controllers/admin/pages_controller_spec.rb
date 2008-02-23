require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PagesController do
  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @page = mock_model(Page)
      @page.stub!(:update_attributes).and_return(true)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :page => {
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      }
    end

    it 'updates the page' do
      @page.should_receive(:update_attributes).with(
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      )

      do_put
    end

    it 'it redirects to edit' do
      do_put
      response.should be_redirect
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @page = mock_model(Page)
      @page.stub!(:update_attributes).and_return(false)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :page => {}
    end

    it 'renders edit' do
      do_put
      response.should render_template('edit')
    end

    it 'is unprocessable' do
      do_put
      response.headers['Status'].should == '422 Unprocessable Entity'
    end
  end

  describe 'handling PUT to update with valid attributes, YAML request' do
    before(:each) do
      @page = mock_model(Page)
      @page.stub!(:update_attributes).and_return(true)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      request.env['RAW_POST_DATA'] = {'page' => {
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      }}.to_yaml
      request.headers['HTTP_X_ENKIHASH'] = hash_request(request)
      put :update, :id => 1, :format => 'yaml'
    end

    it 'updates the page' do
      @page.should_receive(:update_attributes).with(
        'title' => 'My Post',
        'slug'  => 'my-post',
        'body'  => 'This is my post'
      )

      do_put
    end
    
    it 'is successful' do
      do_put
      response.should be_success
    end
  end

  describe 'handling PUT to update with invalid attributes, YAML request' do
    before(:each) do
      @page = mock_model(Page)
      @page.stub!(:update_attributes).and_return(false)
      Page.stub!(:find).and_return(@page)
    end

    def do_put
      request.env['RAW_POST_DATA'] = {}.to_yaml
      request.headers['HTTP_X_ENKIHASH'] = hash_request(request)
      put :update, :id => 1, :format => 'yaml'
    end

    it 'is unprocessable' do
      do_put
      response.headers['Status'].should == '422 Unprocessable Entity'
    end
  end
end
