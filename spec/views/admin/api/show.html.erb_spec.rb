require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/api/show.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render with key' do
    assigns[:key] = 'IAMKEY'
    render '/admin/api/show.html.erb'
    response.should have_text(/IAMKEY/)
  end
end
