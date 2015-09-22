require File.dirname(__FILE__) + '/../spec_helper'

describe PageTitleHelper do
  include PageTitleHelper

  def enki_config
    {:title => 'Blog Title'}
  end

  describe '#posts_title with no tag' do
    it 'is the site title' do
      expect(posts_title(nil)).to eq("Blog Title")
    end
  end

  describe '#posts_title with tag' do
    it 'is the titlelized tag name plus the site title' do
      expect(posts_title("ruby")).to eq("Ruby - Blog Title")
    end
  end

  describe '#post_title' do
    it 'is the post title plus the site title' do
      expect(posts_title("My Post")).to eq("My Post - Blog Title")
    end
  end

  describe '#archives_title' do
    it 'is "Archives" plus the site title' do
      expect(archives_title).to eq("Archives - Blog Title")
    end
  end

  describe '#page_title' do
    it 'is the page title plus the site title' do
      expect(posts_title("My Page")).to eq("My Page - Blog Title")
    end
  end

  describe '#html_title' do
    it 'uses the given string when present' do
      expect(html_title('a')).to eq("a")  
    end

    it 'defaults to the configured title if nothing is supplied' do
      expect(html_title('' )).to eq("Blog Title")  
      expect(html_title(nil)).to eq("Blog Title")  
    end
  end
end
