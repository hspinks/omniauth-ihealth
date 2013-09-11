require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class IHealth < OmniAuth::Strategies::OAuth2

      AVAILABLE_API_NAMES = "OpenApiBP OpenApiWeight"

      def initialize(*args)
        super
        options.name = "ihealth"
        options.provider_ignores_state = true

        options.client_options = {
            :site => options.use_sandbox ?  'http://sandboxapi.ihealthlabs.com' : 'https://api.ihealthlabs.com:8443',
            :authorize_url => '/api/OAuthv2/userauthorization.ashx',
            :token_url  => '/api/OAuthv2/userauthorization.ashx',
            :token_method =>:get
        }

        options.authorize_params = {
            :APIName => AVAILABLE_API_NAMES,
        }

      end

      uid { raw_info['id'] }
    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'