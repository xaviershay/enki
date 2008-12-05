class Page < ActiveRecord::Base
  validates_presence_of :title, :slug, :body

  before_validation     :generate_slug

  before_save           :apply_filter

  class << self
    def build_for_preview(params)
      page = Page.new(params)
      page.apply_filter
      page
    end
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def active?
    true
  end

  def destroy_with_undo
    transaction do
      self.destroy
      return DeletePageUndo.create_undo(self)
    end
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end
end
