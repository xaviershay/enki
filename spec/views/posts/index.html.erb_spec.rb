require File.dirname(__FILE__) + '/../../spec_helper'

describe "/posts/index.html.erb" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)

    mock_tag = mock_model(Tag,
      :name => 'code'
    )

    mock_post = mock_model(Post,
      :title             => "A post",
      :body_html         => "Posts contents!",
      :published_at      => 1.year.ago,
      :slug              => 'a-post',
      :approved_comments => [mock_model(Comment)],
      :tags              => [mock_tag]
    )

    assign :posts, [mock_post, mock_post]
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it "should render list of posts" do
    render :template => "/posts/index.html.erb"
  end

  it "should render list of posts with a tag" do
    assigns[:tag] = 'code'
    render :template => "/posts/index.html.erb"
  end
end
