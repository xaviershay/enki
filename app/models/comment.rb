class Comment < ActiveRecord::Base
  attr_accessor :openid_error
  attr_accessor :openid_valid

  belongs_to :post

  before_save :apply_filter

  validates_presence_of :author
  validates_presence_of :body

  validates_presence_of :post

  def validate
    super 
    errors.add(:base, openid_error) unless openid_error.blank?
  end

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body)
  end

  def requires_openid_authentication?
    self.author.index(".")
  end
end
