require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/posts/show.html.erb" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :post, Post.new(
      :title        => 'A Post',
      :published_at => Time.now,
      :slug         => 'a-post'
    )
    render :template => '/admin/posts/show.html.erb'
  end
end
