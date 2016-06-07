require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe Post, "integration" do
  describe 'setting tag_list' do
    it 'increments tag counter cache' do
      post1 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      post2 = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
      expect(ActsAsTaggableOn::Tag.find_by_name('ruby').taggings_count).to eq(2)
      Post.last.destroy
      expect(ActsAsTaggableOn::Tag.find_by_name('ruby').taggings_count).to eq(1)
    end
  end
end

describe Post, "#find_recent" do
  before(:each) do
    FactoryGirl.create_list(:post, Post::DEFAULT_LIMIT)
  end

  it 'finds the posts that were published before now and return them in published_at DESC order' do
    previously_published_post = Post.take
    previously_published_post.title = "Yesterday's post"
    previously_published_post.published_at_natural = 'yesterday'
    previously_published_post.save

    result = Post.find_recent
    expect(result.last.title).to eq("Yesterday's post")
  end

  it 'allows override of the default limit' do
    result = Post.find_recent(:limit => 1)
    expect(result.size).to be 1
  end

  it 'returns the default number of records when no limit override is provided' do
    FactoryGirl.create(:post)

    result = Post.find_recent
    expect(result.size).to be Post::DEFAULT_LIMIT
  end
end

describe Post, '#find_all_grouped_by_month' do
  it 'finds all posts and returns them grouped by month, in published_at DESC order' do
    FactoryGirl.create(:post, :published_at_natural => 'last month')
    FactoryGirl.create(:post, :published_at_natural => 'now')
    FactoryGirl.create(:post, :published_at_natural => 'now')
    date_time = DateTime.now
    this_month = date_time.month
    previous_month = (date_time << 1).strftime('%-m').to_i

    result = Post.find_all_grouped_by_month

    expect(result[0].date.month).to eq this_month
    expect(result[1].date.month).to eq previous_month
    expect(result[0].posts.size).to be 2
    expect(result[1].posts.size).to be 1
  end
end

describe Post, '#generate_slug' do
  it 'makes a slug from the title if slug if blank' do
    post = Post.new(:slug => '', :title => 'my title')
    post.generate_slug
    expect(post.slug).to eq('my-title')
  end

  it 'replaces & with and' do
    post = Post.new(:slug => 'a & b & c')
    post.generate_slug
    expect(post.slug).to eq('a-and-b-and-c')
  end

  it 'replaces non alphanumeric characters with -' do
    post = Post.new(:slug => 'a@#^*(){}b')
    post.generate_slug
    expect(post.slug).to eq('a-b')
  end

  it 'does not modify title' do
    post = Post.new(:title => 'My Post')
    post.generate_slug
    expect(post.title).to eq('My Post')
  end
end

describe Post, '#tag_list=' do
  it 'accepts an array argument so it is symmetrical with the reader' do
    p = Post.new
    p.tag_list = ["a", "b"]
    expect(p.tag_list).to eq(["a", "b"])
  end

  it 'filters the tag list and keeps only alphanumeric, underscore, space, dot and dash characters' do
    p = Post.new
    p.tag_list = 'square, triangle, oblong, whacky-& $#*wild-1.0'
    expect(p.tag_list).to eq(['square', 'triangle', 'oblong', 'whacky-and wild-1.0'])
  end
end

describe Post, "#set_dates" do
  describe 'when minor_edit is false' do
    it 'sets edited_at to current time' do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)

      post = Post.new(:edited_at => 1.day.ago)
      allow(post).to receive(:minor_edit?).and_return(false)
      post.set_dates
      expect(post.edited_at).to eq(now)
    end
  end

  describe 'when edited_at is nil' do
    it 'sets edited_at to current time' do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)

      post = Post.new
      allow(post).to receive(:minor_edit?).and_return(true)
      post.set_dates
      expect(post.edited_at).to eq(now)
    end
  end

  describe 'when minor_edit is true' do
    it 'does not changed edited_at' do
      post = Post.new(:edited_at => now = 1.day.ago)
      allow(post).to receive(:minor_edit?).and_return(true)
      post.set_dates
      expect(post.edited_at).to eq(now)
    end
  end

  it 'sets published_at by parsing published_at_natural with chronic' do
    now = Time.now
    post = Post.new(:published_at_natural => 'now')
    expect(Chronic).to receive(:parse).with('now').and_return(now)
    post.set_dates
    expect(post.published_at).to eq(now)
  end

  it 'does not set published_at if published_at_natural is invalid' do
    pub = 1.day.ago
    post = Post.new(:published_at_natural => 'bogus', :published_at => pub)
    expect(Chronic).to receive(:parse).with('bogus').and_return(nil)
    post.set_dates
    expect(post.published_at).to eq(pub)
  end

  it 'preserves published_at if published_at_natural is nil' do
    pub = 1.day.ago
    post = Post.new(:published_at_natural => nil, :published_at => pub)

    post.set_dates
    # Some rounding/truncating is acceptable...
    expect(post.published_at).to be_within(60.seconds).of(pub)
  end

  it 'clears published_at if published_at_natural is empty' do
    pub = 1.day.ago
    post = Post.new(:published_at_natural => '', :published_at => pub)
    post.set_dates
    expect(post.published_at).to eq(nil)
  end
end

describe Post, "#minor_edit" do
  it('returns "1" by default') { expect(Post.new.minor_edit).to eq("1") }
end

describe Post, '#published?' do
  before(:each) do
    @post = Post.new
  end

  it "should return false if published_at is not filled" do
    expect(@post).not_to be_published
  end

  it "should return true if published_at is filled" do
    @post.published_at = Time.now
    expect(@post).to be_published
  end
end

describe Post, "#minor_edit?" do
  it('returns true when minor_edit is 1')  { expect(Post.new(:minor_edit => "1").minor_edit?).to eq(true) }
  it('returns false when minor_edit is 0') { expect(Post.new(:minor_edit => "0").minor_edit?).to eq(false) }
  it('returns true by default')            { expect(Post.new.minor_edit?).to eq(true) }
end

describe Post, 'before validation' do
  it 'calls #generate_slug' do
    post = Post.new(:title => "My Post", :body => "body")
    post.valid?
    expect(post.slug).not_to be_blank
  end

  it 'calls #set_dates' do
    post = Post.new(:title => "My Post",
                    :body => "body",
                    :published_at_natural => 'now')
    post.valid?
    expect(post.edited_at).not_to be_blank
    expect(post.published_at).not_to be_blank
  end
end

describe Post, '#denormalize_comments_count!' do
  it 'updates approved_comments_count without triggering AR callbacks' do
    post = Post.create!(:title => 'My Post', :body => "body", :tag_list => "ruby")
    comment_count = 42
    allow(post).to receive(:approved_comments).and_return(double("approved_comments association", :count => comment_count))

    expect(post).to receive(:update_column).with(:approved_comments_count, comment_count)
    post.denormalize_comments_count!
  end
end

describe Post, 'validations' do
  def valid_post_attributes
    {
      :title                => "My Post",
      :slug                 => "my-post",
      :body                 => "hello this is my post",
      :published_at_natural => 'now'
    }
  end

  it 'is valid with valid_post_attributes' do
    expect(Post.new(valid_post_attributes)).to be_valid
  end

  it 'is invalid with no title' do
    expect(Post.new(valid_post_attributes.merge(:title => ''))).not_to be_valid
  end

  it 'is invalid with no body' do
    expect(Post.new(valid_post_attributes.merge(:body => ''))).not_to be_valid
  end

  it 'is invalid with bogus published_at_natural' do
    expect(Post.new(valid_post_attributes.merge(:published_at_natural => 'bogus'))).not_to be_valid
  end
end

describe Post, 'being destroyed' do
  it 'destroys all comments' do
    expect(Post.reflect_on_association(:comments).options[:dependent]).to eq(:destroy)
  end
end

describe Post, '.build_for_preview' do
  before(:each) do
    @post = Post.build_for_preview(:title => 'My Post',
                                   :body => "body",
                                   :tag_list => "ruby",
                                   :published_at_natural => 'now')
  end

  it 'returns a new post' do
    expect(@post).to be_new_record
  end

  it 'generates slug' do
    expect(@post.slug).not_to be_nil
  end

  it 'sets date' do
    expect(@post.edited_at).not_to be_nil
    expect(@post.published_at).not_to be_nil
  end

  it 'applies filter to body' do
    expect(@post.body_html).to eq('<p>body</p>')
  end

  it 'generates tags from tag_list' do
    expect(@post.tags.collect {|tag| tag.name}).to eq(['ruby'])
  end
end
