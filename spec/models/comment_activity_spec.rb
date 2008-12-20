require File.dirname(__FILE__) + '/../spec_helper'

describe CommentActivity, '#comments' do
  it 'finds the 5 most recent approved comments for the post' do
    ret = [mock_model(Comment)]
    comments = []
    comments.should_receive(:find_recent).with(hash_including(:limit => 5)).and_return(ret)
    post = mock_model(Post)
    post.stub!(:approved_comments).and_return(comments)
    CommentActivity.new(post).comments.should == ret
  end

  it 'is memoized to avoid excess hits to the DB' do
    post = mock_model(Post)
    activity = CommentActivity.new(post)

    post.should_receive(:approved_comments).once.and_return(stub_everything)
    2.times { activity.comments }
  end
end
