require File.dirname(__FILE__) + '/../../spec_helper'

describe PostsController do
  describe "route generation" do
    it 'maps show' do
      route_for(:controller => 'admin/sessions', :action => 'show').should == "/admin/session"
    end

    it 'maps new' do
      route_for(:controller => 'admin/sessions', :action => 'new').should == "/admin/session/new"
    end
  end

  describe "route recognition" do
    it 'generates show params' do
      params_from(:get, "/admin/session").should == {:controller => 'admin/sessions', :action => 'show'}
    end

    it 'generates new params' do
      params_from(:get, "/admin/session/new").should == {:controller => 'admin/sessions', :action => 'new'}
    end

    it 'generates destroy params' do
      params_from(:delete, "/admin/session").should == {:controller => 'admin/sessions', :action => 'destroy'}
    end
  end
end
