require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/show.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:page] = Page.new(
      :title      => 'A Post',
      :created_at => Time.now,
      :slug       => 'a-page'
    )
    render '/admin/pages/show.html.erb'
  end
end
