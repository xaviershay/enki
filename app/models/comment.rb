class Comment < ActiveRecord::Base
  acts_as_defensio_comment :fields => { :content => :body, :article => :post }
    
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
    self.body_html = Lesstile.format_as_xhtml(
      self.body,
      :code_formatter => Lesstile::CodeRayFormatter
    )
  end

  def requires_openid_authentication?
    self.author.index(".")
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end
end
