require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/comments/show.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :comment, Comment.new(
      :author                  => 'Don Alias',
      :author_url              => 'http://enkiblog.com',
      :author_email            => 'donalias@enkiblog.com',
      :body                    => 'Hello I am a post',
      :created_at              => Time.now
    )
    allow_message_expectations_on_nil
    assigns[:comment].stub!(:post).and_return(mock_model(Post,
      :title        => 'A post',
      :slug         => 'a-post',
      :published_at => Time.now
    ))
    render :template => '/admin/comments/show.html.erb'
  end
end
