module UrlHelper
  def post_path(post, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    path = post.published_at.strftime("/%Y/%m/%d/") + post.slug + suffix
    path = URI.join(enki_config[:url], path) if options[:only_path] == false
    path
  end

  def post_comments_path(post)
    post_path(post) + "/comments"
  end

  def author_link(comment)
    if comment.author_url.blank?
     comment.author
    else
      link_to(comment.author, comment.author_url, :class => 'openid')
    end
  end
end
