class Page < ActiveRecord::Base
  validates_presence_of :title

  before_save   :apply_filter

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def active?
    true
  end
end
