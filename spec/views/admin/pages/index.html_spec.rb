require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/index.html" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    pages = [mock_model(Page,
      :title      => 'A page',
      :body       => 'Hello I am a page',
      :slug       => 'a-page',
      :created_at => Time.now
    )]
    pages.stub!(:total_pages).and_return(1)
    assign :pages, pages
    render :template => '/admin/pages/index', :formats => [:html]
  end
end
