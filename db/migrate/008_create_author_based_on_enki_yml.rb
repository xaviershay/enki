require 'uri'
require 'yaml'

class CreateAuthorBasedOnEnkiYml < ActiveRecord::Migration

  # Kept here for old time's sake
  class Author < ActiveRecord::Base
    validates_presence_of :name, :email
    validate :open_id_valid

    class << self
      # Finds the author with open_id matching the given open_id address
      def with_open_id(open_id)
        uri = URI.parse(open_id)
        find(:all).detect {|a| a.open_id == uri}
      end
    end

    def open_id
      @open_id || URI.parse(read_attribute(:open_id))
    end
    def open_id=(uri)
      @open_id = begin
        URI.parse(uri)
      rescue URI::InvalidURIError
        nil
      end
      write_attribute(:open_id, uri.to_s)
    end

    private
      def open_id_valid
        unless self.open_id && (self.open_id.is_a?(URI::HTTP) || self.open_id.is_a?(URI::HTTPS))
          errors.add(:open_id, "not a valid OpenID URL")
        end
      end
  end
  
  def self.up
    enki_config = YAML.load(File.read(File.join(RAILS_ROOT, "config", "enki.yml")))
    if author = enki_config["author"]
      author = Author.new :name    => enki_yml_author["name"],
                          :email   => enki_yml_author["email"],
                          :open_id => enki_yml_author["open_id"]
      author.save!
      STDERR.puts "You can now remove the author fields from config/enki.yml"
      STDERR.puts "Dont forget to add an exception_notifications: entry with your email address to config/enki.yml"
    end
  rescue ActiveRecord::RecordInvalid
    raise "Migration from the legacy author fields in your config/enki.yml failed:\n#{author.errors.full_messages.join("\n\t")}"
  end

  def self.down
  end
end
