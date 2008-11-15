require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/show.html.erb" do
  include UrlHelper

  before(:each) do
    @page = mock_model(Page,
      :title             => "A page",
      :body_html         => "Page content!",
      :slug              => 'a-page'
    )
    assigns[:page]    = @page
  end

  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it "should render a page" do
    render "/pages/show.html.erb"
  end
end
