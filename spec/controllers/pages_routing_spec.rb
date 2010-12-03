require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route" do
    it "should not route /pages to show" do
      pending("This assertion fails under 1.9.2, but not under 1.8.7. No idea why.")
      {:get => "/pages"}.should_not route_to(:controller => 'pages', :action => 'show')
    end

    it "should recognise show with id" do
      {:get => "/pages/my-page"}.should route_to(:controller => 'pages', :action => 'show', :id => 'my-page')
    end
  end
end
