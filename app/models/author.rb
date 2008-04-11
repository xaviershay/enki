class Author < ActiveRecord::Base
  validates_presence_of :name, :email
  validate :open_id_valid
  
  has_many :posts

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
