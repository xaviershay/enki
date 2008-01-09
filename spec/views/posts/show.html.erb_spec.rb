require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/show.html.erb" do
  include UrlHelper

  before(:each) do
    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_comment = mock_model(Comment,
      :created_at              => 1.month.ago,
      :author                  => "Don Alias",
      :author_url              => "http://roboblog.com",
      :author_openid_authority => "http://roboblog.com/server",
      :body_html               => "A comment"
    )

    @post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :created_at        => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_comment],
      :tags              => [mock_tag]
    )
    assigns[:post]    = @post
    assigns[:comment] = Comment.new
  end

  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it "should render a post" do
    render "/posts/show.html.erb"
  end
end
