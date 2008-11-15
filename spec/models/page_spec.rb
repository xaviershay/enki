require File.dirname(__FILE__) + '/../spec_helper'

describe Page, '.build_for_preview' do
  before(:each) do
    @page = Page.build_for_preview(:title => 'My Page', :body => "body")
  end

  it 'returns a new page' do
    @page.should be_new_record
  end
  
  it 'applies filter to body' do
    @page.body_html.should == '<p>body</p>'
  end
end
