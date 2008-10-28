# Rails 1.x dependent code (tested on 1.2.6)

module ActionView::Helpers::TextHelper
  alias_method :strip_tags_without_untaint, :strip_tags
  
  def strip_tags(html)
    str = strip_tags_without_untaint(html)
    str.untaint
    str
  end
end
