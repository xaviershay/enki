class Post < ActiveRecord::Base
  acts_as_taggable

  has_many :comments

  before_create :generate_slug
  before_save   :apply_filter

  validates_presence_of :title
  validates_presence_of :body

  class << self
    def find_recent(options = {})
      find(:all, {:order => 'created_at DESC'}.merge(options))
    end

    def find_by_permalink(year, month, day, slug)
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        post = find_all_by_slug(slug).detect do |post|
          post.created_at.midnight == day
        end 
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end
  end

  def apply_filter
    self.body_html = RedCloth.new(self.body).to_html
  end

  protected

  def generate_slug
    self.slug ||= self.title
    self.slug.slugorize!
  end
end
