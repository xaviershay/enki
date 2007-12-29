class Comment < ActiveRecord::Base
  belongs_to :post

  before_save :apply_filter

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body)
  end
end
