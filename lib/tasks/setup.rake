desc "Setup the app by loading the schema and creating an author"
task :setup => "db:schema:load" do
  begin
    require 'highline'
    h = HighLine.new
    puts "Schema loaded. Now to create an Author:"
    Author.create! :name    => h.ask("Name? "),
                   :email   => h.ask("Email? "),
                   :open_id => URI.parse(h.ask("OpenID URL (with http://)? "))
    puts "Done! Now simply customise config/enki.yml and you're done."
  rescue ActiveRecord::RecordInvalid => e
    raise "Could not create Author account: #{e.message}"
  end
end
