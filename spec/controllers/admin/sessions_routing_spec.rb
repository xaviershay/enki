require File.dirname(__FILE__) + '/../../spec_helper'

describe PostsController do
  describe "route" do
    it 'generates show params' do
      {:get => "/admin/session"}.should route_to(:controller => 'admin/sessions', :action => 'show')
    end

    it 'generates new params' do
      {:get => "/admin/session/new"}.should route_to(:controller => 'admin/sessions', :action => 'new')
    end

    it 'generates destroy params' do
      {:delete => "/admin/session"}.should route_to(:controller => 'admin/sessions', :action => 'destroy')
    end
  end
end
