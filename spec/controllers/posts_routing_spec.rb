require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  describe "route" do
    it "should generate index params" do
      {:get => "/"}.should route_to(:controller => "posts", :action => "index", :format => nil)
      {:get => "/posts.atom"}.should route_to(:controller => "posts", :action => "index", :format => "atom")
    end

    it "should generate tag params" do
      {:get => "/code"}.should route_to(:controller => "posts", :action => "index", :tag => "code", :format => nil)
      {:get => "/code.atom"}.should route_to(:controller => "posts", :action => "index", :tag => "code", :format => "atom")
    end

    it "should generate the correct params when the tag name contains a dot character" do
      {:get => "/enki.o"}.should route_to(:controller => "posts", :action => "index", :tag => "enki.o", :format => nil)
      {:get => "/enki.o.atom"}.should route_to(:controller => "posts", :action => "index", :tag => "enki.o", :format => "atom")
    end

    it "should route /pages to posts#index with tag pages" do
      {:get => "/pages"}.should route_to(:controller => "posts", :action => "index", :tag => "pages", :format => nil)
    end

    it "should generate show params" do
      {:get => "/2008/02/01/a-post"}.should route_to(:controller => "posts", :action => "show", :year => "2008", :month => "02", :day => "01", :slug => "a-post")
    end
  end
end
