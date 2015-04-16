class CreateOmniAuthDetails < ActiveRecord::Migration
  def change
    create_table :omni_auth_details do |t|
      t.string :provider,   :null => false
      t.string :uid,        :null => false
      t.text :info,         :null => false
      t.text :credentials
      t.text :extra

      t.timestamps
    end
  end
end
