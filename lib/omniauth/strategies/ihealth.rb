require 'omniauth-oauth2'
# require 'oauth2'

module OmniAuth
  module Strategies
    class IHealth < OmniAuth::Strategies::OAuth2

      AVAILABLE_API_NAMES = "OpenApiActivity OpenApiBG OpenApiBP OpenApiSleep OpenApiSpO2 OpenApiUserInfo OpenApiWeight"
      DEFAULT_API_NAMES = "OpenApiUserInfo"

      option :name, 'ihealth'
      option :scope, DEFAULT_API_NAMES
      option :provider_ignores_state, true

      option :client_options, {
        :site => 'https://api.ihealthlabs.com:8443',
        :authorize_url => '/OpenApiV2/OAuthv2/userauthorization/',
        :token_url => '/OpenApiV2/OAuthv2/userauthorization/',
        :token_method => :get,
        :parse => :json
      }

      def authorize_params
        super.tap do |params|
          params[:response_type] = 'code'
          params[:APIName] = options.scope
        end
      end

      def token_params
        super.tap do |params|
          params[:client_id] = client.id
          params[:client_secret] = client.secret
          params[:grant_type] = "authorization_code"
        end
      end

      def build_access_token
        token_url_params = {:code => request.params['code'], :redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true))
        parsed_response = client.request(options.client_options.token_method, client.token_url(token_url_params), parse: :json).parsed
        hash = {
          :access_token => parsed_response["AccessToken"],
          :expires_in => parsed_response["Expires"],
          :refresh_token => parsed_response["RefreshToken"],
          :user_id => parsed_response["UserID"],
          :api_name => parsed_response["APIName"],
          :client_para => parsed_response["client_para"]
        }
        ::OAuth2::AccessToken.from_hash(client, hash)
      end

      uid { access_token[:user_id] }

      info { user_data.slice(:name, :nickname, :image) }

      extra do
        { :user_info => user_data, :raw_info => raw_info }
      end

      def raw_info
        access_token.options[:mode] = :query
        user_profile_params = {:client_id => client.id, :client_secret => client.secret, :access_token => access_token.token}
        user_profile_params.merge({:sc => options.sc, :sv => options.sv}) if options.sc && options.sv
        @raw_info ||= access_token.get("/openapiv2/user/#{access_token[:user_id]}.json/?#{user_profile_params.to_param}", parse: :json).parsed
      end

      def user_data
        info = raw_info
        if !user_data
          user_data = {}
          user_data[:name]     = info["nickname"]           if info["nickname"]
          user_data[:nickname] = info["nickname"]           if info["nickname"]
          user_data[:gender]   = info["gender"]             if info["gender"]
          user_data[:image]    = URI.unescape(info["logo"]) if info["logo"]
          user_data[:height]   = calc_height(info["height"], info["HeightUnit"]) if info["height"] && info["HeightUnit"]
          user_data[:weight]   = calc_weight(info["weight"], info["WeightUnit"]) if info["weight"] && info["WeightUnit"]
          user_data[:birthday] = Time.at(info["dateofbirth"]).to_date.strftime("%Y-%m-%d") if info["dateofbirth"]
        end
        user_data
      end

      protected
      CM_TO_IN_CONVERSION = 0.393701
      FT_TO_IN_CONVERSION = 12
      def calc_height(value, unit)
        case(unit)
        when 0  # value is in cm
          return value * CM_TO_IN_CONVERSION
        when 1  # value is in feet
          return value * FT_TO_IN_CONVERSION
        else    # unrecognized unit
          return value
        end
      end

      KG_TO_LBS_CONVERSION = 2.20462
      STONE_TO_LBS_CONVERSION = 14
      def calc_weight(value, unit)
        case(unit)
        when 0  # value is in kg
          return value * KG_TO_LBS_CONVERSION
        when 1  # value is in lbs
          return value
        when 2  # value is in stone
          return value * STONE_TO_LBS_CONVERSION
        else    # unrecognized unit
          return value
        end
      end

    end
  end
end


OmniAuth.config.add_camelization 'ihealth', 'IHealth'