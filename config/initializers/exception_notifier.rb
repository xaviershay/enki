Enki::Application.config.middleware.use ExceptionNotifier,
  :ignore_exceptions    => [ActionController::InvalidAuthenticityToken],
  :email_prefix         => "[Enki] ",
  :sender_address       => [Enki::Config.default[:author, :email]],
  :exception_recipients => [Enki::Config.default[:author, :email]]
