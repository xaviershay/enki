require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route recognition" do
    it "should not route /pages to show" do
      params_from(:get, "/pages").should_not == {:controller => 'pages', :action => 'show'}
    end

    it "should recognise show with id" do
      params_from(:get, "/pages/my-page").should == {:controller => 'pages', :action => 'show', :id => 'my-page'}
    end
  end
end
