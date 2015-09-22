require File.dirname(__FILE__) + '/../spec_helper'

describe DeleteCommentUndo do
  describe '#process!' do
    it 'creates a new comment based on the attributes stored in #data' do
      allow(Comment).to receive(:find_by_id).and_return(nil)

      item = DeleteCommentUndo.new(:data => "---\nid: 1\na: b")
      allow(item).to receive(:transaction).and_yield
      allow(item).to receive(:destroy)

      expect(Comment).to receive(:create).with('a' => 'b').and_return(double("comment", :new_record? => false))
      item.process!
    end
  end

  describe '#process! with existing comment' do
    it 'raises' do
      allow(Comment).to receive(:find_by_id).and_return(Object.new)
      expect { DeleteCommentUndo.new(:data => "---\nid: 1").process! }.to raise_error(UndoFailed)
    end
  end

  describe '#process! with invalid comment' do
    it 'raises' do
      allow(Comment).to receive(:find_by_id).and_return(nil)

      allow(Comment).to receive(:create).and_return(double("comment", :new_record? => true))
      expect { DeleteCommentUndo.new(:data => "---\nid: 1").process! }.to raise_error(UndoFailed)
    end
  end

  describe '#description' do
    it("should not be nil") { expect(DeleteCommentUndo.new(:data => "--- {}\n").description).not_to be_nil }
  end

  describe '#complete_description' do
    it("should not be nil") { expect(DeleteCommentUndo.new(:data => "--- {}\n").complete_description).not_to be_nil }
  end

  describe '.create_undo' do
    it "creates a new undo item based on the attributes of the given comment" do
      comment = Comment.new(:author => 'Don Alias')
      expect(DeleteCommentUndo).to receive(:create!).with(:data => comment.attributes.to_yaml).and_return(obj = Object.new)
      expect(DeleteCommentUndo.create_undo(comment)).to eq(obj)
    end
  end
end
