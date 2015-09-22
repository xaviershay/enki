module UrlHelper
  def post_path(post, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    path = post.published_at.strftime("/%Y/%m/%d/") + post.slug + suffix
    path = "#{Rails.configuration.action_controller.relative_url_root}#{path}"
    path = URI.join(enki_config[:url], path) if options[:full_url] == true
    path
  end

  def post_comments_path(post, comment)
    post_path(post) + "/comments"
  end

  def author_link(comment)
    if comment.author_url.blank?
     comment.author
    else
      link_to(comment.author, comment.author_url, :class => 'openid')
    end
  end

  def link_to_post(post, link_text=post.title)
    if post.published?
      link_to(link_text, post_path(post))
    else
      link_text
    end
  end

  def link_to_post_comments(post)
    link_text = pluralize(post.approved_comments.size, "comment")
    if post.published?
      link_to(link_text, post_path(post, :anchor => 'comments'))
    else
      # Posts would have to be published to be on the public index,
      # the only place where a fragment won't work.
      link_to(link_text, '#comments')
    end
  end
end
