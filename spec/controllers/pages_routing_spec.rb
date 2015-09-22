require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route" do
    it "should recognise show with id" do
      expect({:get => "/pages/my-page"}).to route_to(:controller => 'pages', :action => 'show', :id => 'my-page')
    end
  end
end
