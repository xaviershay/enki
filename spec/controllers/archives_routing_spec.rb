require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'route generation' do
    it 'maps index' do
      route_for(:controller => "archives", :action => "index").should == "/archives"
    end
  end

  describe 'route recognition' do
    it 'generates index params' do
      params_from(:get, '/archives').should == {:controller => 'archives', :action => 'index'}
    end
  end
end
