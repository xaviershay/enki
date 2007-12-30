class DefensioMigrationGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :assigns => {
        :table_name => @name.tableize, :class_name => @name.classify.pluralize
      }, :migration_file_name => "add_defensio_columns_to_#{@name.tableize}"
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} defensio_migration model"
    end
end
