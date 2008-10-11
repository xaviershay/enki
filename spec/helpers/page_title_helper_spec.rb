require File.dirname(__FILE__) + '/../spec_helper'

describe PageTitleHelper do
  include PageTitleHelper

  def config
    {:title => 'Blog Title'}
  end

  describe '#posts_title with no tag' do
    it 'is the site title' do
      posts_title(nil).should == "Blog Title"
    end
  end

  describe '#posts_title with tag' do
    it 'is the titlelized tag name plus the site title' do
      posts_title("ruby").should == "Ruby - Blog Title"
    end
  end

  describe '#post_title' do
    it 'is the post title plus the site title' do
      posts_title("My Post").should == "My Post - Blog Title"
    end
  end

  describe '#archives_title' do
    it 'is "Archives" plus the site title' do
      archives_title.should == "Archives - Blog Title"
    end
  end

  describe '#page_title' do
    it 'is the page title plus the site title' do
      posts_title("My Page").should == "My Page - Blog Title"
    end
  end
end
