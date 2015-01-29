require 'bundler/setup'
require 'sinatra'
require_relative 'secret_config'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == SecretConfig.username && password == SecretConfig.password
end

before do
  @time_last_accessed ||= Time.now
  @msg = { status: 'success', content: 'Ready to connect to Coinsetter' }
  # auth into coinsetter
end

get '/' do
  erb :index
end