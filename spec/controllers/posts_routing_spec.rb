require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  describe "route" do
    it "should generate index params" do
      expect({:get => "/"}).to route_to(:controller => "posts", :action => "index", :format => nil)
      expect({:get => "/posts.atom"}).to route_to(:controller => "posts", :action => "index", :format => "atom")
    end

    it "should generate tag params" do
      expect({:get => "/code"}).to route_to(:controller => "posts", :action => "index", :tag => "code", :format => nil)
      expect({:get => "/code.atom"}).to route_to(:controller => "posts", :action => "index", :tag => "code", :format => "atom")
    end

    it "should generate the correct params when the tag name contains a dot character" do
      expect({:get => "/enki.o"}).to route_to(:controller => "posts", :action => "index", :tag => "enki.o", :format => nil)
      expect({:get => "/enki.o.atom"}).to route_to(:controller => "posts", :action => "index", :tag => "enki.o", :format => "atom")
    end

    it "should route /pages to posts#index with tag pages" do
      expect({:get => "/pages"}).to route_to(:controller => "posts", :action => "index", :tag => "pages", :format => nil)
    end

    it "should generate show params" do
      expect({:get => "/2008/02/01/a-post"}).to route_to(:controller => "posts", :action => "show", :year => "2008", :month => "02", :day => "01", :slug => "a-post")
    end
  end
end
