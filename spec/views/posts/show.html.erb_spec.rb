require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/show.html.erb" do
  include UrlHelper

  before(:each) do
    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_comment = mock_model(Comment,
      :created_at              => 1.month.ago,
      :author                  => "Don Alias".taint,
      :author_url              => "http://enkiblog.com".taint,
      :author_openid_authority => "http://enkiblog.com/server".taint,
      :body_html               => "A comment"
    )

    mock_comment2 = mock_model(Comment,
      :created_at              => 1.month.ago,
      :author                  => "Don Alias".taint,
      :author_url              => ''.taint,
      :body_html               => "A comment"
    )

    @post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_comment, mock_comment2],
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
