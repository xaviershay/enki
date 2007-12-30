class Post < ActiveRecord::Base
  acts_as_defensio_article 
  acts_as_taggable

  has_many :comments
  has_many :approved_comments, :class_name => 'Comment', :conditions => 'comments.spam = 0'

  before_create :generate_slug
  before_save   :apply_filter

  validates_presence_of :title
  validates_presence_of :body

  class << self
    def find_recent(options = {:limit => 15})
      find(:all, {:order => 'posts.created_at DESC'}.merge(options))
    end

    def find_recent_by_tag(tag, options = {:limit => 15})
      find_tagged_with(tag, {:order => 'posts.created_at DESC'}.merge(options))
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
    self.body_html = Lesstile.format_as_xhtml(
      self.body,
      :text_formatter => lambda {|text| RedCloth.new(text).to_html},
      :code_formatter => Lesstile::CodeRayFormatter
    )  
  end

  protected

  def generate_slug
    self.slug ||= self.title
    self.slug.slugorize!
  end
end
