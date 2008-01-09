require File.dirname(__FILE__) + '/../spec_helper'

describe Post, ".find_recent" do
  it 'finds the most recent posts that were published before now' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    Post.should_receive(:find).with(:all, {
      :order      => 'posts.created_at DESC',
      :conditions => ['published_at < ?', now],
      :limit      => Post::DEFAULT_LIMIT
    })
    Post.find_recent
  end

  it 'finds the most recent posts that were published before now with a tag' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    Post.should_receive(:find_tagged_with).with('code', {
      :order      => 'posts.created_at DESC',
      :conditions => ['published_at < ?', now],
      :limit      => Post::DEFAULT_LIMIT
    })
    Post.find_recent(:tag => 'code')
  end
end
