require 'bundler/setup'
require 'sinatra'
require_relative 'secret_config'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == SecretConfig.username && password == SecretConfig.password
end

before do
  @time_last_accessed ||= Time.now
  @msg ||= { status: 'info', content: "Ready, IP: #{request.env['REMOTE_ADDR']}" }
end

get '/' do
  erb :index
end

def login_to_coinsetter
  url, parameters = SecretConfig.coinsetter_url, SecretConfig.coinsetter_login_params(request)
  RestClient.post(url, parameters) do |response, request, result, &block|
    # coming soon
  end
  
  js :login
end