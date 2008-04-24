require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/pages/index.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:pages] = [mock_model(Page,
      :title      => 'A page',
      :body       => 'Hello I am a page',
      :slug       => 'a-page',
      :created_at => Time.now
    )]
    assigns[:pages].stub!(:page_count).and_return(1)
    render '/admin/pages/index.html.erb'
  end
end
