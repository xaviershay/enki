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

  it 'finds all posts grouped by month' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    posts = [1, 1, 2].collect {|month| mock_model(Post, :month => month) }
    Post.should_receive(:find).with(:all, {
      :order      => 'posts.published_at DESC',
      :conditions => ['published_at < ?', now]
    }).and_return(posts)
    months = Post.find_all_grouped_by_month.collect {|month| [month.date, month.posts]}
    months.should == [[1, [posts[0], posts[1]]], [2, [posts[2]]]]
  end
end
