require 'bundler/setup'
require 'sinatra'
require 'rest-client'
# require 'pry'

require_relative 'secret_config'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == SecretConfig.username && password == SecretConfig.password
end

before do
  @ip ||= get_static_ip
  @logged_in ||= login_to_coinsetter
  @msg ||= @logged_in ? { status: 'success', content: "Logged In" } : { status: 'info', content: "" }
end

get '/' do
  erb :index
end

get '/login_to_coinsetter' do
  login_to_coinsetter
  
  erb :'login_to_coinsetter.js', :layout => false
end

get '/get_account_data' do
  @account_data = request_coinsetter_data('/customer/account', {'coinsetter-client-session-id' => @api_session})
  
  erb :'get_account_data.js', :layout => false
end

# internal methods

def get_static_ip
  RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"] || SecretConfig.quotaguard_static_url
  res = RestClient.get("http://ip.jsontest.com")
  return JSON.parse(res.body)['ip']
end

def login_to_coinsetter
  response_hash = request_coinsetter_data('/clientSession', SecretConfig.coinsetter_login_params(@ip))
  url = SecretConfig.coinsetter_url + '/clientSession'
  
  @api_session, @customer_uuid = response_hash['uuid'], response_hash['customerUuid']
  status = response_hash['requestStatus'] == 'SUCCESS' ? 'success' : 'danger'
  content = status == 'success' ? 'Logged In' : 'Something Went Wrong'
  
  @msg = { status: status, content: content }

  return @msg[:status] == 'success'
end

def request_coinsetter_data(path, parameters)
  url = SecretConfig.coinsetter_url + path
  parameters = parameters.to_json
  headers = {content_type: :json, accept: :json}
  
  RestClient.post(url, parameters, headers) do |response, request, result, &block|
  # RestClient::Request.execute(:method => :post, :url => url, :payload => parameters,
  # :headers => headers, :verify_ssl => false) do |response, request, result, &block|
    
    return JSON.parse(response)
  end
  
  return response_hash
end