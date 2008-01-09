require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.erb" do
  before(:each) do
    mock_tag = mock_model_with_stubs(Tag,
      :name => 'code'
    )

    mock_post = mock_model_with_stubs(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :created_at        => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_model(Comment)],
      :tags              => [mock_tag]
    )

    assigns[:posts] = [mock_post, mock_post]
  end

  it "should render list of posts" do
    render "/posts/index.html.erb"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render "/posts/index.html.erb"
  end
end
