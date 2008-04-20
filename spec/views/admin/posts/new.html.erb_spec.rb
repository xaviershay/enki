require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/posts/new.html.erb" do
  after(:each) do
    response.should be_valid_xhtml_fragment
  end

  it 'should render' do
    assigns[:post] = Post.new
    render '/admin/posts/new.html.erb'
  end
end
