require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/new.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:page] = Page.new
    render '/admin/pages/new.html.erb'
  end
end
