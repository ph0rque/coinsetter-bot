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
  @msg ||= { status: 'info', content: "" }
end

get '/' do
  erb :index
end

get '/login_to_coinsetter' do
  url, parameters = SecretConfig.coinsetter_url, SecretConfig.coinsetter_login_params(@ip)
  RestClient.post(url, parameters) do |response, request, result, &block|
puts response
puts result
    @msg = { status: 'info', content: response }
  end
  
  erb :'login_to_coinsetter.js'
end

def get_static_ip
  RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"] || SecretConfig.quotaguard_static_url
  res = RestClient.get("http://ip.jsontest.com")
  return JSON.parse(res.body)['ip']
end
  