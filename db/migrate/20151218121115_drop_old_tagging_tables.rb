class DropOldTaggingTables < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? 'tags'
      drop_table 'tags'
    end

    if ActiveRecord::Base.connection.table_exists? 'taggings'
      drop_table 'taggings'
    end

    if index_exists?(:taggings, 'index_taggings_on_taggable_id_and_taggable_type')
      remove_index :taggings, :name => 'index_taggings_on_taggable_id_and_taggable_type'
    end

    if index_exists?(:taggings, 'index_taggings_on_tag_id')
      remove_index :taggings, :name => 'index_taggings_on_tag_id'
    end

    if index_exists?(:tags, 'index_tags_on_name')
      remove_index :tags, :name => 'index_tags_on_name'
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
