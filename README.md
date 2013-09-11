# Omniauth Strategy for iHealth
This is a strategy to connect with iHealth using Ommniauth and OAuth 2.0


## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-ihealth', :git=>'https://github.com/ArturKarbone/omniauth-ihealth.git'
```

Then `bundle install`.

## Usage


Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ihealth, ENV['KEY'], ENV['SECRET']
end
```


## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `use_sandbox`: Use sandbox urls. false by default

For example, to test in sandbox mode

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['KEY'], ENV['SECRET'],:use_sandbox => true
end
```
