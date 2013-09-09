require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class IHealth < OmniAuth::Strategies::OAuth2

      option :name, "ihealth"

      option :client_options, {
        #:site          => 'https://api.ihealthlabs.com:8443',
        :site => 'http://sandboxapi.ihealthlabs.com',
        :authorize_url => '/api/OAuthv2/userauthorization.ashx',
        :token_url  => '/api/OAuthv2/userauthorization.ashx',
      }

      option :authorize_params, {
          :APIName => 'OpenApiBP OpenApiWeight',
      }

      uid { raw_info['id'] }

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.refresh_token
        hash
      end
      
    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'