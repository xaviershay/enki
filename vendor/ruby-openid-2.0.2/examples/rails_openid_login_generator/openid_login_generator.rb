class OpenidLoginGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      
      # Login module, controller class, functional test, and helper.
      m.template "openid_login_system.rb", "lib/openid_login_system.rb"
      m.template "controller.rb", File.join("app/controllers", class_path, "#{file_name}_controller.rb")
      m.template "controller_test.rb", File.join("test/functional", class_path, "#{file_name}_controller_test.rb")
      m.template "helper.rb", File.join("app/helpers", class_path, "#{file_name}_helper.rb")

      # Model class, unit test, fixtures, and example schema.
      m.template "user.rb", "app/models/user.rb"
      m.template "user_test.rb", "test/unit/user_test.rb"
      m.template "users.yml", "test/fixtures/users.yml"

      # Layout and stylesheet.
      m.template "scaffold:layout.rhtml", "app/views/layouts/scaffold.rhtml"
      m.template "scaffold:style.css", "public/stylesheets/scaffold.css"

      # Views. 
      m.directory File.join("app/views", class_path, file_name)
      login_views.each do |action|
        m.template "view_#{action}.rhtml",
          File.join("app/views", class_path, file_name, "#{action}.rhtml")
      end

      m.template "README", "README_LOGIN"
    end
  end

  attr_accessor :controller_class_name
  
  def login_views
    %w(welcome login logout)
  end
end
