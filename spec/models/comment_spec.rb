require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  def valid_comment_attributes(extra = {})
    {
      :author => 'Don Alias',
      :body   => 'This is a comment',
      :post   => Post.new
    }.merge(extra)
  end

  before(:each) do
    @comment = Comment.new
  end

  it "is invalid with no post" do
    @comment.attributes = valid_comment_attributes(:post => nil)
    @comment.should_not be_valid
    @comment.errors.on(:post).should_not be_blank
  end

  it "is invalid with no body" do
    @comment.attributes = valid_comment_attributes(:body => '')
    @comment.should_not be_valid
    @comment.errors.on(:body).should_not be_blank
  end

  it "is invalid with no author" do
    @comment.attributes = valid_comment_attributes(:author => '')
    @comment.should_not be_valid
    @comment.errors.on(:author).should_not be_blank
  end

  it "is valid with a full set of valid attributes" do
    @comment.attributes = valid_comment_attributes
    @comment.should be_valid
  end
end
