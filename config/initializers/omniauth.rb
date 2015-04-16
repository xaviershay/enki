require 'omniauth-openid'
require 'openid/store/filesystem'

OmniAuth.config.logger = Rails.logger

# Uncomment this if you want OmniAuth error responses to work as in production.
#OmniAuth.config.on_failure = Proc.new { |env|
#  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
#}

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
        :scope => 'openid,email'
    }
    provider :open_id, :name => 'open_id_admin', :store => OpenID::Store::Filesystem.new('/tmp')
    provider :open_id, :name => 'open_id_comment', :store => OpenID::Store::Filesystem.new('/tmp')
end
