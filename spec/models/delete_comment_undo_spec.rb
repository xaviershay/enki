require File.dirname(__FILE__) + '/../spec_helper'

describe DeleteCommentUndo do
  describe '#process!' do
    it 'creates a new comment based on the attributes stored in #data' do
      Comment.stub!(:find_by_id).and_return(nil)
      
      item = DeleteCommentUndo.new(:data => "---\nid: 1\na: b")
      item.stub!(:transaction).and_yield
      item.stub!(:destroy)

      Comment.should_receive(:create).with('a' => 'b').and_return(mock("comment", :new_record? => false))
      item.process!
    end
  end

  describe '#process! with existing comment' do
    it 'raises' do
      Comment.stub!(:find_by_id).and_return(Object.new)
      lambda { DeleteCommentUndo.new(:data => "---\nid: 1").process! }.should raise_error(UndoFailed)
    end
  end

  describe '#process! with invalid comment' do
    it 'raises' do
      Comment.stub!(:find_by_id).and_return(nil)

      Comment.stub!(:create).and_return(mock("comment", :new_record? => true))
      lambda { DeleteCommentUndo.new(:data => "---\nid: 1").process! }.should raise_error(UndoFailed)
    end
  end

  describe '#description' do
    it("should not be nil") { DeleteCommentUndo.new(:data => '---').description.should_not be_nil }
  end

  describe '#complete_description' do
    it("should not be nil") { DeleteCommentUndo.new(:data => '---').complete_description.should_not be_nil }
  end

  describe '.create_undo' do
    it "creates a new undo item based on the attributes of the given comment" do
      comment = Comment.new(:author => 'Don Alias')
      DeleteCommentUndo.should_receive(:create!).with(:data => comment.attributes.to_yaml).and_return(obj = Object.new)
      DeleteCommentUndo.create_undo(comment).should == obj
    end
  end
end
