require File.dirname(__FILE__) + '/../spec_helper'

describe CommentMailer do
  
  before(:each) do
    @comment = Comment.new({
      :author => 'Don Alias',
      :body   => 'This is a comment',
      :post   => Post.new
    })
    @comment.apply_filter
  end
  
  describe "notification" do
    
    before(:each) do
      @mailer = CommentMailer.create_notification(@comment)
    end

    it "should set the correct from using enki configuration" do
      @mailer.from.should == ["don@enkiblog.com"]
    end

    it "should set the correct to using enki configuration" do
      @mailer.to.should == ["don@enkiblog.com"]
    end

    it "should set the correct subject using enki configuration" do
      @mailer.subject.should == "New comment notification"
    end
    
    it "should have right body" do
      @mailer.body.should == "New comment on .\n\nThis is a comment\n"
    end
    

  end
  
  
end
