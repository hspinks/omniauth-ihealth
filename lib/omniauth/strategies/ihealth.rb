require 'omniauth-oauth2'
# require 'httparty'
# require 'awesome_print'

module OmniAuth
  module Strategies
    class IHealth < OmniAuth::Strategies::OAuth2

      AVAILABLE_API_NAMES = "OpenApiActivity OpenApiBG OpenApiBP OpenApiSleep OpenApiSpO2 OpenApiUserInfo OpenApiWeight"

      option :name, 'ihealth'
      option :provider_ignores_state, true

      option :client_options, {
        :site => 'https://api.ihealthlabs.com:8443',
        :authorize_url => '/OpenApiV2/OAuthv2/userauthorization/',
        :token_url => '/OpenApiV2/OAuthv2/userauthorization/',
        :token_method => :get
      }

      option :authorize_params, {
        :response_type => 'code',
        :APIName => AVAILABLE_API_NAMES
      }

      option :token_params, {
        :grant_type => "authorization_code"
      }

      def token_params
        super.tap do |params|
          params[:client_id] = options.client_id
          params[:client_secret] = options.client_secret
        end
      end

      # def build_access_token
      #   puts "------------------------------"
      #   verifier = request.params['code']
      #   uri = options.client_options.site + options.client_options.token_url
      #   body = {:code => verifier, :redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true))
      #   url = uri + "?" + body.to_query
      #   puts url
      #   response = HTTParty.get(url)
      #   ap response
      # end

      uid { raw_info['id'] }

    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'