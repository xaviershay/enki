require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/comments/show.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:comment] = Comment.new(
      :author                  => 'Don Alias',
      :author_url              => 'http://enkiblog.com',
      :author_openid_authority => 'http://example.com',
      :author_email            => 'donalias@enkiblog.com',
      :body                    => 'Hello I am a post',
      :created_at              => Time.now
    )
    assigns[:comment].stub!(:post).and_return(mock_model(Post,
      :title        => 'A post',
      :slug         => 'a-post',
      :published_at => Time.now
    ))
    render '/admin/comments/show.html.erb'
  end
end
