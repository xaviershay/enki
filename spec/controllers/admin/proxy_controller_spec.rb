require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ProxyController do
  describe 'handling GET to index' do
    before do
      stub_response = {'content-type' => 'application/atom+xml; charset=utf-8'}
      stub_response.stub!(:body).and_return('hello')

      Net::HTTP.should_receive(:start).and_return(stub_response)
      session[:logged_in] = true
      get :index, :id => 'http://example.com/feed'
    end

    it 'proxies the call to the remote server specified in :id' do
      response.should be_success
      response.body.should == 'hello'
    end

    it 'passes through the content type of the proxied URL so that jQuery can parse it correctly' do
      response.headers['type'].should == 'application/atom+xml; charset=utf-8'
    end
  end
end
