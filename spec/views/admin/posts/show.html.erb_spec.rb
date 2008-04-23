require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/posts/show.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:post] = Post.new(
      :title        => 'A Post',
      :published_at => Time.now,
      :slug         => 'a-post'
    )
    render '/admin/posts/show.html.erb'
  end
end
