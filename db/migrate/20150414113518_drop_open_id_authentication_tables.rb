class DropOpenIdAuthenticationTables < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? 'open_id_authentication_associations'
      drop_table 'open_id_authentication_associations'
    end

    if ActiveRecord::Base.connection.table_exists? 'open_id_authentication_nonces'
      drop_table 'open_id_authentication_nonces'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
