require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/show.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :page, Page.new(
      :title      => 'A Post',
      :created_at => Time.now,
      :slug       => 'a-page'
    )
    render :template => '/admin/pages/show.html.erb'
  end
end
