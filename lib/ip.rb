# frozen_string_literal: true

require 'sinatra'
require 'json'

get '/' do
  { "ip": request.ip }.to_json
end
