require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  describe "route generation" do
    it "should map index" do
      route_for(:controller => "posts", :action => "index").should == "/"
      route_for(:controller => "posts", :action => "index", :format => 'atom').should == "/posts.atom"
    end

    it "should map index with tag" do
      route_for(:controller => "posts", :action => "index", :tag => 'code').should == "/code"
      route_for(:controller => "posts", :action => "index", :tag => 'code', :format => 'atom').should == "/code.atom"
    end
  end

  describe "route recognition" do
    it "should generate index params" do
      params_from(:get, "/").should == {:controller => "posts", :action => "index"}
      params_from(:get, "/posts.atom").should == {:controller => "posts", :action => "index", :format => 'atom'}
    end

    it "should generate tag params" do
      params_from(:get, "/code").should == {:controller => "posts", :action => "index", :tag => "code"}
      params_from(:get, "/code.atom").should == {:controller => "posts", :action => "index", :tag => "code", :format => 'atom'}
    end

    it "should generate show params" do
      params_from(:get, "/2008/02/01/a-post").should == {:controller => "posts", :action => "show", :year => '2008', :month => '02', :day => '01', :slug => 'a-post'}
    end
  end
end
