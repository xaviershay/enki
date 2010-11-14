require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/new.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :page, Page.new
    render :template => '/admin/pages/new.html.erb'
  end
end
