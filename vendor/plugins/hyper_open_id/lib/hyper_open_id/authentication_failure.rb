require 'openid'

class HyperOpenID::AuthenticationFailure < OpenID::OpenIDError
  attr_accessor :response

  def initialize(response)
    @response = response
  end

  def identity_url
    @response.identity_url
  end
end
