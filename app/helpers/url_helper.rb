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
    if comment.author_url.blank?
      comment.author
    else
      link_to(comment.author, comment.author_url, :title => "Authenticated by #{comment.author_openid_authority}", :class => 'openid')
    end
  end
end
