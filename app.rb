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
  
  @customer_uuid = SecretConfig.coinsetter_customer_uuid
  @msg ||= @logged_in ? { status: 'success', content: "Logged In" } : { status: 'info', content: "" }
end

get '/' do
  erb :index
end

get '/login_to_coinsetter' do  
  erb :'login_to_coinsetter.js', :layout => false
end

get '/get_account_data' do
  header = {'coinsetter-client-session-id' => @api_session}
  account_data = request_coinsetter_data(:get, '/customer/account', {}, header)['accountList'][0]
  
  @btc_balance, @usd_balance = account_data['btcBalance'], account_data['usdBalance']
  
  erb :'get_account_data.js', :layout => false
end

# internal methods

def get_static_ip
  RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"] || SecretConfig.quotaguard_static_url
  res = RestClient.get("http://ip.jsontest.com")
  return JSON.parse(res.body)['ip']
end

def login_to_coinsetter
  response_hash = request_coinsetter_data(:post, '/clientSession', SecretConfig.coinsetter_login_params(@ip))
  url = SecretConfig.coinsetter_url + '/clientSession'
  
  @api_session, @customer_uuid = response_hash['uuid'], response_hash['customerUuid']
  status = response_hash['requestStatus'] == 'SUCCESS' ? 'success' : 'danger'
  content = status == 'success' ? 'Logged In' : 'Something Went Wrong'
  
  @msg = { status: status, content: content }

  return @msg[:status] == 'success'
end

def request_coinsetter_data(method, path, parameters = {}, headers = {})
  api_hash = {
    method: method,
    url: SecretConfig.coinsetter_url + path,
    payload: parameters.to_json,
    headers: {content_type: :json, accept: :json}.merge(headers)
  }
  
  # api_hash[:verify_ssl] = false # for localhost testing
  
  RestClient::Request.execute(api_hash) do |response, request, result, &block|
    return JSON.parse(response)
  end
end