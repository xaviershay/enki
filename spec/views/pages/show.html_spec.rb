require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/show.html" do
  include UrlHelper

  before(:each) do
    allow(view).to receive(:enki_config).and_return(Enki::Config.default)

    @page = mock_model(Page,
      :title             => "A page",
      :body_html         => "Page content!",
      :slug              => 'a-page'
    )
    assign :page, @page
  end

  after(:each) do
    expect(rendered).to be_valid_html5_fragment
  end

  it "should render a page" do
    render :template => "/pages/show", :formats => [:html]
  end
end
