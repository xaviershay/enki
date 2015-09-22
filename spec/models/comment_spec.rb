require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe Comment do
  def valid_comment_attributes(extra = {})
    {
      :author => 'Don Alias',
      :body   => 'This is a comment',
      :post   => Post.new
    }.merge(extra)
  end

  def set_comment_attributes(comment, extra = {})
    valid_comment_attributes(extra).each_pair do |key, value|
      comment.send("#{key}=", value)
    end
  end

  before(:each) do
    @comment = Comment.new
  end

  it "is invalid with no post" do
    set_comment_attributes(@comment, :post => nil)
    expect(@comment).not_to be_valid
    expect(@comment.errors).not_to be_empty
  end

  it "is invalid with no body" do
    set_comment_attributes(@comment, :body => '')
    expect(@comment).not_to be_valid
    expect(@comment.errors).not_to be_empty
  end

  it "is invalid with no author" do
    set_comment_attributes(@comment, :author => '')
    expect(@comment).not_to be_valid
    expect(@comment.errors).not_to be_empty
  end

  it "is valid with a full set of valid attributes" do
    set_comment_attributes(@comment)
    expect(@comment).to be_valid
  end

  it "requires OpenID authentication when the author's name looks like a url" do
    @comment.author = "Don Alias"
    expect(@comment.requires_openid_authentication?).to eq(false)
    @comment.author = "enkiblog.com"
    expect(@comment.requires_openid_authentication?).to eq(true)
  end

  it "doesn't require auth just because the author's name contains a dot" do
    @comment.author = "Dr. Alias"
    expect(@comment.requires_openid_authentication?).to eq(false)
  end

  it "requires OpenID authentication when the author's name starts with http" do
    @comment.author = "http://localhost:9294"
    expect(@comment.requires_openid_authentication?).to eq(true)
    @comment.author = "https://localhost:9294"
    expect(@comment.requires_openid_authentication?).to eq(true)
  end

  it "asks post to update it's comment counter after save" do
    set_comment_attributes(@comment)
    @comment.blank_openid_fields
    @comment.post.update_attributes(:title => 'My Post', :body => "body")
    @comment.post.save
    @comment.save
    expect(@comment.post.approved_comments.count).to eq(1)
  end

  it "asks post to update it's comment counter after destroy" do
    set_comment_attributes(@comment)
    @comment.blank_openid_fields
    @comment.post.update_attributes(:title => 'My Post', :body => "body")
    @comment.post.save
    @comment.save
    @comment.destroy
    expect(@comment.post.approved_comments.count).to eq(0)
  end

  it "applies a Lesstile filter to body and store it in body_html before save" do
    set_comment_attributes(@comment)
    @comment.blank_openid_fields
    @comment.post.update_attributes(:title => 'My Post', :body => "body")
    @comment.post.save
    @comment.save
    expect(@comment.body_html).not_to be_nil
  end

  it "responds to trusted_user? for defensio integration" do
    expect(@comment.respond_to?(:trusted_user?)).to eq(true)
  end

  it "responds to user_logged_in? for defensio integration" do
    expect(@comment.respond_to?(:user_logged_in?)).to eq(true)
  end

  it "delegates post_tile to post" do
    @comment.post = mock_model(Post)
    expect(@comment.post).to receive(:title).and_return("hello")
    expect(@comment.post_title).to eq("hello")
  end

  # TODO: acts_as_defensio_comment tests
  # TODO: OpenID error model
end

describe Comment, '#blank_openid_fields_if_unused' do
  before(:each) do
    @comment = Comment.new
    @comment.blank_openid_fields
  end

  it('blanks out author_url')              { expect(@comment.author_url).to eq('') }
  it('blanks out author_email')            { expect(@comment.author_email).to eq('') }
end

describe Comment, '.find_recent' do
  before(:each) do
      FactoryGirl.create_list(:comment, Comment::DEFAULT_LIMIT + 1)
  end

  it 'finds comments and returns them in created_at DESC order' do
    result = Comment.find_recent
    expect(result[0].created_at).to be > result[1].created_at
  end

  it 'allows override of the default limit' do
    result = Comment.find_recent(:limit => 1)
    expect(result.size).to be 1
  end

  it 'returns the default number of records when no limit override is provided' do
    result = Comment.find_recent
    expect(result.size).to be Comment::DEFAULT_LIMIT
  end
end

describe Comment, '.build_for_preview' do
  before(:each) do
    @comment = Comment.build_for_preview(:author => 'Don Alias', :body => 'A Comment')
  end

  it 'returns a new comment' do
    expect(@comment).to be_new_record
  end

  it 'sets created_at' do
    expect(@comment.created_at).not_to be_nil
  end

  it 'applies filter to body' do
    expect(@comment.body_html).to eq('A Comment')
  end
end

describe Comment, '.build_for_preview with OpenID author' do
  before(:each) do
    @comment = Comment.build_for_preview(:author => 'http://enkiblog.com', :body => 'A Comment')
  end

  it 'returns a new comment' do
    expect(@comment).to be_new_record
  end

  it 'sets created_at' do
    expect(@comment.created_at).not_to be_nil
  end

  it 'applies filter to body' do
    expect(@comment.body_html).to eq('A Comment')
  end

  it 'sets author_url to OpenID identity' do
    expect(@comment.author_url).to eq('http://enkiblog.com')
  end

  it 'sets author to "Your OpenID Name"' do
    expect(@comment.author).to eq("Your OpenID Name")
  end
end

describe Comment, '#requires_openid_authentication?' do
  describe 'with an author that looks like a url' do
    subject { Comment.new(:author => 'example.com').requires_openid_authentication? }

      it { is_expected.to be }
  end

  describe 'with a normal author' do
    subject { Comment.new(:author => 'Don Alias').requires_openid_authentication? }

    it { is_expected.not_to be }
  end

  describe 'with a nil author' do
    subject { Comment.new.requires_openid_authentication? }

    it { is_expected.not_to be }
  end
end
