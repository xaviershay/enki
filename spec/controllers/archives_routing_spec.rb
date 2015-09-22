require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'route' do
    it 'generates index params' do
      expect({:get => '/archives'}).to route_to(:controller => 'archives', :action => 'index')
    end
  end
end
