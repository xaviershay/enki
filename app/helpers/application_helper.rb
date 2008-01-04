# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def config
    @@config = Roboblog::Config.new("config/roboblog.yml")
  end

  def author
    Struct.new(:name, :email).new(config[:author], config[:email])
  end

  def posts_title(tag)
    [tag, config[:title]].compact.join(" - ") 
  end

  def open_id_delegation_link_tags(server, delegate)
    links = <<-EOS
      <link rel="openid.server" href="#{server}" />
      <link rel="openid.delegate" href="#{delegate}" />
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
