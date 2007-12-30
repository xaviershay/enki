class Page < ActiveRecord::Base
  validates_presence_of :title

  before_save   :apply_filter

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(
      self.body,
      :text_formatter => lambda {|text| RedCloth.new(text).to_html},
      :code_formatter => Lesstile::CodeRayFormatter
    )  
  end

  def active?
    true
  end
end
