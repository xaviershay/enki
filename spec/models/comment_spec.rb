require File.dirname(__FILE__) + '/../spec_helper'

describe 'Comment', :shared => true do
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

  it "is invalid with no post" do
    set_comment_attributes(@comment, :post => nil)
    @comment.should_not be_valid
    @comment.errors.on(:post).should_not be_blank
  end

  it "is invalid with no body" do
    set_comment_attributes(@comment, :body => '')
    @comment.should_not be_valid
    @comment.errors.on(:body).should_not be_blank
  end

  it "is invalid with no author" do
    set_comment_attributes(@comment, :author => '')
    @comment.should_not be_valid
    @comment.errors.on(:author).should_not be_blank
  end

  it "is valid with a full set of valid attributes" do
    set_comment_attributes(@comment)
    @comment.should be_valid
  end

  it "requires OpenID authentication when the author's name contains a period" do
    @comment.author = "Don Alias"
    @comment.requires_openid_authentication?.should == false
    @comment.author = "roboblog.com"
    @comment.requires_openid_authentication?.should == true
  end

  it "asks post to update it's comment counter after save" do
    @comment.class.after_save.include?(:denormalize).should == true
    @comment.post = mock_model(Post)
    @comment.post.should_receive(:denormalize_comments_count!)
    @comment.denormalize
  end

  it "applies a Lesstile filter to body and store it in body_html before save" do
    @comment.class.before_save.include?(:apply_filter).should == true
    Lesstile.should_receive(:format_as_xhtml).and_return("formatted")
    @comment.apply_filter
  end

  it "responds to trusted_user? for defensio integration" do
    @comment.respond_to?(:trusted_user?).should == true
  end

  it "responds to user_logged_in? for defensio integration" do
    @comment.respond_to?(:user_logged_in?).should == true
  end

  it "delegates post_tile to post" do
    @comment.post = mock_model(Post)
    @comment.post.should_receive(:title).and_return("hello")
    @comment.post_title.should == "hello"
  end

  # TODO: acts_as_defensio_comment tests
  # TODO: OpenID error model
end

describe "A comment from a user" do
  before(:each) do
    @comment = Comment.new
  end

  it_should_behave_like('Comment')

  describe 'mass assignment' do
    it "allows setting of author" do
      @comment.update_attributes(:author => 'Don Alias')
      @comment.author.should == 'Don Alias'
    end

    it "allows setting of body" do
      @comment.update_attributes(:body => 'This is a comment')
      @comment.body.should == 'This is a comment'
    end

    it "forbids setting of author_url" do
      @comment.update_attributes(:author_url => 'http://roboblog.com')
      @comment.author_url.should be_blank
    end

    it "forbids setting of author_email" do
      @comment.update_attributes(:author_email => 'donalias@roboblog.com')
      @comment.author_email.should be_blank
    end

    it "forbids setting of author_openid_authority" do
      @comment.update_attributes(:author_openid_authority => 'http://roboblog.com/openid_server')
      @comment.author_openid_authority.should be_blank
    end
    
    it "forbids setting of created_at" do
      @comment.update_attributes(:created_at => 1.year.ago)
      @comment.created_at.should be_nil
    end

    it "forbids setting of updated_at" do
      @comment.update_attributes(:updated_at => 1.year.ago)
      @comment.updated_at.should be_nil
    end

    it "forbids setting of spam" do
      @comment.update_attributes(:spam => 1)
      @comment.spam.should == false
    end

    it "forbids setting of spaminess" do
      @comment.update_attributes(:spaminess => 0.3)
      @comment.spaminess.should be_nil
    end

    it "forbids setting of signature" do
      @comment.update_attributes(:signature => 'rt3ienrt823wontsriun3iunrst3rsitun3')
      @comment.signature.should be_nil
    end
  end
end

describe 'A comment being editted by an admin' do
  before(:each) do
    @comment = UnsafeComment.new
  end

  it_should_behave_like('Comment')

  describe 'mass assignment' do
    it "allows setting of author" do
      @comment.update_attributes(:author => 'Don Alias')
      @comment.author.should == 'Don Alias'
    end

    it "allows setting of body" do
      @comment.update_attributes(:body => 'This is a comment')
      @comment.body.should == 'This is a comment'
    end
    
    it "allows setting of author_url" do
      @comment.update_attributes(:author_url => 'http://roboblog.com')
      @comment.author_url.should == 'http://roboblog.com'
    end

    it "allows setting of author_email" do
      @comment.update_attributes(:author_email => 'donalias@roboblog.com')
      @comment.author_email.should == 'donalias@roboblog.com'
    end

    it "allows setting of author_openid_authority" do
      @comment.update_attributes(:author_openid_authority => 'http://roboblog.com/openid_server')
      @comment.author_openid_authority.should == 'http://roboblog.com/openid_server'
    end

    it "forbids setting of created_at" do
      @comment.update_attributes(:created_at => 1.year.ago)
      @comment.created_at.should be_nil
    end

    it "forbids setting of updated_at" do
      @comment.update_attributes(:updated_at => 1.year.ago)
      @comment.updated_at.should be_nil
    end

    it "forbids setting of spam" do
      @comment.update_attributes(:spam => 1)
      @comment.spam.should == false
    end

    it "forbids setting of spaminess" do
      @comment.update_attributes(:spaminess => 0.3)
      @comment.spaminess.should be_nil
    end

    it "forbids setting of signature" do
      @comment.update_attributes(:signature => 'rt3ienrt823wontsriun3iunrst3rsitun3')
      @comment.signature.should be_nil
    end
  end
end
