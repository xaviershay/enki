require File.dirname(__FILE__) + '/../spec_helper'

describe UrlHelper do
  include UrlHelper

  describe '#post_path' do
    it 'should prefix slug with published_at' do
      post = double()
      allow(post).to receive(:published_at) { Date.new(2012,1,1) }
      allow(post).to receive(:slug) { 'post' }
      expect(post_path(post)).to eq('/2012/01/01/post')
    end
  end
end
