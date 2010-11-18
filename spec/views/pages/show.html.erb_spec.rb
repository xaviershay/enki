require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/show.html.erb" do
  include UrlHelper

  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    @page = mock_model(Page,
      :title             => "A page",
      :body_html         => "Page content!",
      :slug              => 'a-page'
    )
    assign :page, @page
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "should render a page" do
    render :template => "/pages/show.html.erb"
  end
end
