# TagHelper will output HTML tags as opposed to self-closed XHTML tags.
# Shouldn't be needed for Rails >= version 3.
module ActionView::Helpers::TagHelper
  def tag_with_html_patch(name, options = nil, open = true, escape = true)
    tag_without_html_patch(name, options, true, escape)
  end
  alias_method_chain :tag, :html_patch
end