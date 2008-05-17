require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  describe 'on delete' do
    it 'also deletes all associated taggings' do
      Tag.reflect_on_association(:taggings).options[:dependent].should == :destroy
    end
  end
end
