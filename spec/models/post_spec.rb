require File.dirname(__FILE__) + '/../spec_helper'


describe Post, "integration" do
  describe 'setting tag_list' do
    it 'increments tag counter cache' do
      post1 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      post2 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      Tag.find_by_name('ruby').taggings_count.should == 2
      post2.destroy
      Tag.find_by_name('ruby').taggings_count.should == 1
    end
  end
end

describe Post, ".find_recent" do
  it 'finds the most recent posts that were published before now' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    Post.should_receive(:find).with(:all, {
      :order      => 'posts.published_at DESC',
      :conditions => ['published_at < ?', now],
      :limit      => Post::DEFAULT_LIMIT
    })
    Post.find_recent
  end

  it 'finds the most recent posts that were published before now with a tag' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    Post.should_receive(:find_tagged_with).with('code', {
      :order      => 'posts.published_at DESC',
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

describe Post, '#generate_slug' do
  it 'makes a slug from the title if slug if blank' do
    post = Post.new(:slug => '', :title => 'my title')
    post.generate_slug
    post.slug.should == 'my-title'
  end

  it 'replaces & with and' do
    post = Post.new(:slug => 'a & b & c')
    post.generate_slug
    post.slug.should == 'a-and-b-and-c'
  end

  it 'replaces non alphanumeric characters with -' do
    post = Post.new(:slug => 'a@#^*(){}b')
    post.generate_slug
    post.slug.should == 'a-b'
  end

  it 'does not modify title' do
    post = Post.new(:title => 'My Post')
    post.generate_slug
    post.title.should == 'My Post'
  end
end

describe Post, '#tag_list=' do
  it 'accept an array argument so it is symmetrical with the reader' do
    p = Post.new
    p.tag_list = ["a", "b"]
    p.tag_list.should == ["a", "b"]
  end
end

describe Post, 'before validation' do
  it 'calls #generate_slug' do
    Post.before_validation.include?(:generate_slug).should == true
  end
end

describe Post, '#denormalize_comments_count!' do
  it 'updates approved_comments_count without triggering AR callbacks' do
    p = Post.new
    p.id = 999
    p.stub!(:approved_comments).and_return(stub("approved_comments association", :count => 9))
    Post.should_receive(:update_all).with(["approved_comments_count = ?", 9], ["id = ?", 999])
    p.denormalize_comments_count!
  end
end

describe Post, 'validations' do
  def valid_post_attributes
    {
      :title => "My Post",
      :slug  => "my-post",
      :body  => "hello this is my post"
    }
  end

  it 'is valid with valid_post_attributes' do
    Post.new(valid_post_attributes).should be_valid
  end

  it 'is invalid with no title' do
    Post.new(valid_post_attributes.merge(:title => '')).should_not be_valid
  end

  it 'is invalid with no body' do
    Post.new(valid_post_attributes.merge(:body => '')).should_not be_valid
  end
end

describe Post, 'being destroyed' do
  it 'destroys all comments' do
    Post.reflect_on_association(:comments).options[:dependent].should == :destroy
  end
end
