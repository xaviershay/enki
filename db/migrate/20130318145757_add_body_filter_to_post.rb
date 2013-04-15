class AddBodyFilterToPost < ActiveRecord::Migration
  def change
    add_column :posts, :body_filter, :string, :default => 'lesstile_to_xhtml'
  end
end
