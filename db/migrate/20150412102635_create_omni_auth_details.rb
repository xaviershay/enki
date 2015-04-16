class CreateOmniAuthDetails < ActiveRecord::Migration
  def change
    create_table :omni_auth_details do |t|
      t.string :provider,   :null => false
      t.string :uid
      t.text :info
      t.text :credentials
      t.text :extra

      t.timestamps
    end
  end
end
