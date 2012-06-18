require 'spec_helper'

describe UrlHelper do
  include UrlHelper

  describe '#post_path' do
    it 'should prefix slug with published_at' do
      post = stub(
        :published_at => Date.new(2012,1,1),
        :slug         => 'post'
      )
      post_path(post).should == '/2012/01/01/post'
    end
  end
end
