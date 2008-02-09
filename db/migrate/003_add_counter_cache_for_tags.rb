class AddCounterCacheForTags < ActiveRecord::Migration
  class Tagging < ActiveRecord::Base; end;
  class Tag < ActiveRecord::Base; has_many :taggings; end;

  def self.up
    add_column :tags, :taggings_count, :integer, :default => 0, :null => false

    Tag.find(:all).each do |tag|
      tag.update_attribute(:taggings_count, tag.taggings.count)
    end
  end

  def self.down
    remove_column :tags, :taggings_count
  end
end
