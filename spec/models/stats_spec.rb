require File.dirname(__FILE__) + '/../spec_helper'

describe Stats do
  describe '#post_count' do
    it 'returns the total number of posts, published or not' do
      expect(Post).to receive(:count).and_return(2)
      expect(Stats.new.post_count).to eq(2)
    end
  end

  describe '#comment_count' do
    it 'returns the total number of comments' do
      expect(Comment).to receive(:count).and_return(2)
      expect(Stats.new.comment_count).to eq(2)
    end
  end

  describe '#tag_count' do
    it 'returns the total number of tags' do
      expect(ActsAsTaggableOn::Tag).to receive(:count).and_return(2)
      expect(Stats.new.tag_count).to eq(2)
    end
  end
end
