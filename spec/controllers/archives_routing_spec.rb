require File.dirname(__FILE__) + '/../spec_helper'

describe ArchivesController do
  describe 'route' do
    it 'generates index params' do
      {:get => '/archives'}.should route_to(:controller => 'archives', :action => 'index')
    end
  end
end
