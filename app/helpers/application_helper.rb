module ApplicationHelper
  def author
    Author.find(:first)
  end

  def open_id_delegation_link_tags(server, delegate)
    raw links = <<-EOS
      <link rel="openid.server" href="#{server}">
      <link rel="openid.delegate" href="#{delegate}">
    EOS
  end

  def format_comment_error(error)
    {
      'body'   => 'Please comment',
      'author' => 'Please provide your name or OpenID identity URL',
      'base'   => error.last
    }[error.first]
  end
end
