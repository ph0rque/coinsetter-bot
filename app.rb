require 'bundler/setup'
require 'sinatra'
require 'rest-client'
require_relative 'secret_config'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == SecretConfig.username && password == SecretConfig.password
end

before do
  @time_last_accessed ||= Time.now
  @ip ||= get_static_ip
  @msg ||= { status: 'info', content: "Ready, Static IP: #{@ip}" }
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

def get_static_ip
  RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"]
  res = RestClient.get("http://ip.jsontest.com")
  return JSON.parse(res.body)['ip']
end
  