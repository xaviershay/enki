class DePolymorphiseTaggings < ActiveRecord::Migration
  def self.up
    remove_column :taggings, :taggable_type
  end

  def self.down
    add_column :taggings, :taggable_type, :string
    Tagging.update_all(['taggable_type = ?', 'Post'])
  end
end
