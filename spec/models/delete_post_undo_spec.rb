require File.dirname(__FILE__) + '/../spec_helper'

describe DeletePostUndo do
  describe '#process!' do
    it 'creates a new post with comments based on the attributes stored in #data' do
      post = Post.create!(:title => 'a', :body => 'b').tap do |post|
        post.comments.create!(:author => 'Don', :author_url => '', :author_email => '', :body => 'comment')
      end
      item = post.destroy_with_undo
      new_post = item.process!
      new_post.comments.count.should == 1
    end
  end
end
