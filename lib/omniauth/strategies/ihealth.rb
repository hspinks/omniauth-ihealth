require 'omniauth-oauth2'
require 'oauth2'

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
        :token_method => :get,
        :parse => :json
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

      def build_access_token
        token_url_params = {:code => request.params['code'], :redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true))
        parsed_response = client.request(options.client_options.token_method, client.token_url(token_url_params), parse: :json).parsed
        hash = {
          :access_token => parsed_response["AccessToken"],
          :expires_in => parsed_response["Expires"],
          :refresh_token => parsed_response["RefreshToken"],
          :user_id => parsed_response["UserId"],
          :api_name => parsed_response["APIName"],
          :client_para => parsed_response["client_para"]
        }
        OAuth2::AccessToken.from_hash(client, hash)
      end

      uid { raw_info['id'] }

    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'