require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/dashboard/show.html.erb" do
  before(:each) do
    view.stub!(:enki_config).and_return(Enki::Config.default)
  end

  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :posts, [mock_model(Post,
      :title             => 'A Post',
      :published_at      => Time.now,
      :slug              => 'a-post',
      :approved_comments => []
    )]
    assign :comment_activity, [mock("comment-activity-1",
      :post                => mock_model(Post,
        :published_at      => Time.now,
        :title             => "A Post",
        :slug              => 'a-post',
        :approved_comments => []
      ),
      :comments            => [mock_model(Comment, :author => 'Don', :body_html => 'Hello')],
      :most_recent_comment => mock_model(Comment, :created_at => Time.now, :author => 'Don')
    )]
    assign :stats, Struct.new(:post_count, :comment_count, :tag_count).new(3,2,1)
    render :template => '/admin/dashboard/show.html.erb'
  end
end
