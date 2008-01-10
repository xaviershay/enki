require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sessions/new.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it "renders" do
    render '/admin/sessions/new.html.erb'
  end
end
