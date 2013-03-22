require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ihealth < OmniAuth::Strategies::OAuth2

      option :name, "ihealth"

      option :client_options, {
        :site          => 'https://api.ihealthlabs:8443',
        :authorize_url => '/api/OAuthv2/userauthorization.ashx',
        :token_url     => '/api/OAuthv2/userauthorization.ashx'
      }

      uid { raw_info['id'] }

      info do
        {
          'name'            => raw_info['display_name'],
          'email'           => raw_info['email'],
          'nickname'        => raw_info['nick_name'],
          'first_name'      => raw_info['first_name'],
          'last_name'       => raw_info['last_name'],
          'location'        => '',
          'description'     => '',
          'image'           => raw_info['photos']['thumbnail'] + "?oauth_token=#{access_token.token}",
          'phone'           => '',
          'urls'            => raw_info['urls']
        }
      end

      credentials do
        hash = {'token' => access_token.token}
        hash.merge!('refresh_token' => access_token.refresh_token) if access_token.refresh_token
        hash
      end
      
    end
  end
end