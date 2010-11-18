Enki::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Enki] ",
  :sender_address => [Enki::Config.default[:author, :email]],
  :exception_recipients => [Enki::Config.default[:author, :email]]
