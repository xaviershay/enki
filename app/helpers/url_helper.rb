module UrlHelper
  def posts_path(options = {})
    if options[:tag]
      "/#{options[:tag].name.downcase}"
    else
      "/"
    end
  end

  def post_path(post)
    post.created_at.strftime("/%Y/%m/%d/") + post.slug
  end

  def post_comments_path(post)
    post_path(post) + "/comments"
  end
end
