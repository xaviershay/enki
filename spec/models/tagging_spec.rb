require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
  before(:each) do
    @taggable = Post.create!(:title => 'My Post', :body => 'body', :tag_list => 'oblong, square, triangle')
  end

  it 'destroys unused tags on taggable update' do
    @taggable.tag_list = ''
    @taggable.save
    Tag.where(:taggings_count => 0).count.should == 0
  end

  it 'destroys unused tags on taggable destroy' do
    @taggable.destroy
    Tag.where(:taggings_count => 0).count.should == 0
  end
  
  it 'does not destroy tags if they are still in use' do
    another_taggable = Post.create!(:title => 'My Post', :body => 'body', :tag_list => 'oblong, square')
    @taggable.destroy
    Tag.where(:name => ['oblong', 'square']).count.should == 2
  end
end
