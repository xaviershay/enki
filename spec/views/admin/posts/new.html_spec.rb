require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/posts/new.html" do
  after(:each) do
    rendered.should be_valid_html5_fragment
  end

  it 'should render' do
    assign :post, Post.new
    render :template => '/admin/posts/new', :formats => [:html]
  end
end
