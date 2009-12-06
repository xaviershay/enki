module PageTitleHelper
  def posts_title(tag)
    compose_title((tag || "").to_s.titleize)
  end

  def post_title(post)
    compose_title(post.title)
  end

  def archives_title
    compose_title("Archives")
  end

  def page_title(page)
    compose_title(page.title)
  end

  private

  def compose_title(*parts)
    (parts << config[:title]).reject(&:blank?).join(" - ")
  end
end
