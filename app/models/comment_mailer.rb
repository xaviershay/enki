class CommentMailer < ActionMailer::Base
  
  def notification(comment)
    recipients "#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>"
    from       "#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>"
    subject  "New comment notification"
    body    :post => comment.post, :comment => comment
  end

end
