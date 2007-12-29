module UrlHelper
  def posts_path(options = {})
    if options[:tag]
      "/#{options[:tag].name.downcase}"
    else
      "/"
    end
  end

  def post_path(post, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    post.created_at.strftime("/%Y/%m/%d/") + post.slug + suffix
  end

  def post_comments_path(post)
    post_path(post) + "/comments"
  end

  def author_link(comment)
    comment.author
  end
end
