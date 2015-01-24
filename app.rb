require 'sinatra'
require_relative 'secret_config'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  return username == SecretConfig.username && password == SecretConfig.password
end

before do
  @time_last_accessed ||= Time.now
  # auth into coinsetter
end

get '/' do
  erb :index
end