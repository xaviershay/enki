class UpdateTaggingTables < ActiveRecord::Migration
  def up
    #update tables
    change_column_null :tags, :taggings_count, true

    change_table :taggings do |t|
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :tagger, polymorphic: true
      t.string :taggable_type, null: false, default: 'Post'

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, limit: 128, default: 'tags', null: false
    end
    # set default before to force the db filling this field
    change_column_default(:taggings, :taggable_type, nil)
    change_column_default(:taggings, :context, nil)

    if ActsAsTaggableOn::Utils.using_mysql?
      execute("ALTER TABLE tags MODIFY name varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;")
    end

    #drop old index structures
    ActiveRecord::Base.connection.indexes(:taggings).each do |index|
      remove_index :taggings, :name => index.name
    end
    ActiveRecord::Base.connection.indexes(:tags).each do |index|
      remove_index :tags, :name => index.name
    end

    #create new index structures
    add_index :tags, :name, unique: true
    add_index :taggings,
              [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
              unique: true, name: 'taggings_idx'
    add_index :taggings, [:taggable_id, :taggable_type, :context]

    #update data
    #TODO: test what this really does
    ActsAsTaggableOn::Tag.reset_column_information
    ActsAsTaggableOn::Tag.find_each do |tag|
      ActsAsTaggableOn::Tag.reset_counters(tag.id, :taggings)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
