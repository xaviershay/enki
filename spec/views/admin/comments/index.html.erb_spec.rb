require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/comments/index.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:comments] = [mock_model(Comment,
      :author     => 'Don Alias',
      :body       => 'Hello I am a post',
      :created_at => Time.now,
      :post_title => 'A Post',
      :post => mock_model(Post,
        :slug         => 'a-post',
        :published_at => Time.now
      )
    )]
    assigns[:comments].stub!(:page_count).and_return(1)
    render '/admin/comments/index.html.erb'
  end
end
