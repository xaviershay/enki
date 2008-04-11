class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.string :email
      t.string :open_id
    end
  end

  def self.down
    drop_table :authors
  end
end
