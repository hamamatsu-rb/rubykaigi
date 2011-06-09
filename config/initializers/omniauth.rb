require 'omniauth/openid'
require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, configatron.twitter.consumer_key, configatron.twitter.consumer_secret
  provider :open_id, OpenID::Store::Filesystem.new(Rails.root + 'tmp/openid')
end
