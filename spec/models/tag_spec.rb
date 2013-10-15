require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  describe 'on delete' do
    it 'also deletes all associated taggings' do
      Tag.reflect_on_association(:taggings).options[:dependent].should == :destroy
    end
  end

  describe '#filter_name' do
  	it 'filters the tag name and keeps only alphanumeric, underscore, space, dot and dash characters' do
  		Tag::filter_name('whacky-& $#*wild-1.0').should == 'whacky-and wild-1.0'
  	end
  end
end
