require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/posts/index.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    posts = [mock_model(Post,
      :published_at      => Time.now,
      :title             => 'A post',
      :body              => 'Hello I am a post',
      :slug              => 'a-post',
      :approved_comments => []
    )]
    posts.stub!(:page_count).and_return(1)
    assigns[:posts] = posts
    render '/admin/posts/index.html.erb'
  end
end
