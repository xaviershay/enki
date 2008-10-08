require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/index.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    pages = [mock_model(Page,
      :title      => 'A page',
      :body       => 'Hello I am a page',
      :slug       => 'a-page',
      :created_at => Time.now
    )]
    pages.stub!(:total_pages).and_return(1)
    assigns[:pages] = pages
    render '/admin/pages/index.html.erb'
  end
end
