require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/comments/index.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    comments = [mock_model(Comment,
      :author     => 'Don Alias',
      :body       => 'Hello I am a post',
      :created_at => Time.now,
      :post_title => 'A Post',
      :post => mock_model(Post,
        :slug         => 'a-post',
        :published_at => Time.now
      )
    )]
    comments.stub!(:total_pages).and_return(1)
    assign :comments, comments
    render :template => '/admin/comments/index.html.erb'
  end
end
