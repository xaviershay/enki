class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag, :counter_cache => true
  belongs_to :taggable, :class_name => 'Post', :foreign_key => 'taggable_id' #:polymorphic => true
  
  after_destroy :remove_unused_tags
  
  private
  
  def remove_unused_tags
    Tag.destroy_all :taggings_count => 0 if Tag.destroy_unused
  end
end
