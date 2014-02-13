# Omniauth Strategy for iHealth
This is a strategy to connect with iHealth using Ommniauth and OAuth 2.0. Originally written by [ArturKarbone](https://github.com/ArturKarbone), up to date as of Feb 13, 2014 for iHealth's API.

You can apply for API access on iHealth's developer website [here](http://developer.ihealthlabs.com).


## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-ihealth', :git=>'https://github.com/hspinks/omniauth-ihealth.git'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::IHealth` is a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ihealth, ENV['KEY'], ENV['SECRET']
end
```


## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A list of permissions you want to request from the user, separated by spaces. Options are `OpenApiUserInfo`, `OpenApiActivity`, `OpenApiBG`, `OpenApiBP`, `OpenApiSleep`, `OpenApiSpO2`, and `OpenApiWeight`. You must include `OpenApiUserInfo`. Defaults to `OpenApiUserInfo`.
* `sc`: The Serial Code for the client. You can find this on the developer detail page on iHealth's website [here](http://developer.ihealthlabs.com/developerdetailpage.htm).
* `sv`: The SV value listed for OpenApiUserInfo on the [developer detail page](http://developer.ihealthlabs.com/developerdetailpage.htm).

## Auth Hash

Here's an example Auth Hash available in `request.env['omniauth.auth']`:

```json
{
	:provider => 'ihealth',
	:uid => "12345",
	:info => {
		:name => "John Doe",
		:nickname => "John Doe",
		:image => "https://cloud.ihealthlabs.com/logos/12345.png"
	},
	:credentials => {
		:token => 'ABCDEF...', # OAuth 2.0 access_token
		:refresh_token => 'ABCDEF...',
		:expires_at => '1392501884',
		:expires => true
	},
	:extra => {
		:user_info => {
			:name => "John Doe",
			:gender => "male",
			:birthday => "2013-12-31",
			:image => "https://cloud.ihealthlabs.com/logos/12345.png",
			:nickname => "John Doe",
			:height => 72.00, # height in inches
			:weight => 180.00 # weight in pounds
		},
		:raw_info => {
			:HeightUnit => 0, # 0 for cm, 1 for ft
			:WeightUnit => 0, # 0 for kg, 1 for lbs, 2 for stone
			:dateofbirth => 1388534400,
			:gender => "Male",
			:height => 182.88,
			:logo => "https%3a%2f%2fcloud.ihealthlabs.com%2flogos%2f12345.png",
			:nickname => "John Doe",
			:userid => "12345",
			:weight => 81.6
		}
	}
}
```
