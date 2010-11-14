require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route" do
    it "should not route /pages to show" do
      pending("This assertion does not seem to be doing what you would expect it to do")
      {:get => "/pages"}.should_not route_to(:controller => 'pages', :action => 'show')
    end

    it "should recognise show with id" do
      {:get => "/pages/my-page"}.should route_to(:controller => 'pages', :action => 'show', :id => 'my-page')
    end
  end
end
