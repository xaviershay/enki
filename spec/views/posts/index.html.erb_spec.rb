require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.erb" do
  before(:each) do
    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title             => "A post".taint,
      :body_html         => "Posts contents!".taint,
      :published_at      => 1.year.ago.taint,
      :slug              => 'a-post'.taint,
      :approved_comments => [mock_model(Comment)],
      :tags              => [mock_tag]
    )

    assigns[:posts] = [mock_post, mock_post]
  end

  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it "should render list of posts" do
    render "/posts/index.html.erb"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render "/posts/index.html.erb"
  end
end
