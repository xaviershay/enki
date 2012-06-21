class AddIndexes < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE INDEX posts_slug_unique_idx ON posts (slug)
    SQL

    execute <<-SQL
      CREATE UNIQUE INDEX pages_slug_unique_idx ON pages (slug)
    SQL
  end

  def self.down
    execute "DROP INDEX posts_slug_unique_idx"
    execute "DROP INDEX pages_slug_unique_idx"
  end
end
