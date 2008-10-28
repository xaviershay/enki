# Rails 2.0 dependent code (tested on 2.0.2)

module ActionView::Helpers::SanitizeHelper
  def strip_tags_with_untaint(html)
    str = strip_tags_without_untaint(html)
    str.untaint
    str
  end

  alias_method_chain :strip_tags, :untaint
end
