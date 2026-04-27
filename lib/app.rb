# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'maxmind/db'
require 'sinatra'
require 'erb'
require_relative 'geo_lite_reader'

if Sinatra::Base.development?
  require 'dotenv/load'
  require 'pry'
end

Tilt.register Tilt::ERBTemplate, 'html.erb'

CLI_USER_AGENT = /\A(curl|Wget|HTTPie|fetch|got|libwww-perl|python-requests|powershell)/i

helpers do
  def requested_ip
    request.params['ip'] || request.ip
  end

  def html_browser?
    request.accept.map(&:entry).include?('text/html')
  end

  def cli_client?
    CLI_USER_AGENT.match?(request.user_agent.to_s)
  end

  def json_payload(ip)
    "#{JSON.pretty_generate({ ip: ip }.merge(location_info(ip)))}\n"
  end
end

get '/' do
  @remote_ip = requested_ip

  if html_browser?
    @location = location_info(@remote_ip)
    set_lat_long unless @location.empty?
    erb :ip, { layout: :application }
  elsif cli_client?
    content_type :text
    "#{@remote_ip}\n"
  else
    content_type :json
    json_payload(@remote_ip)
  end
rescue StandardError => e
  Logger.new($stdout).error(e.message)
  status 500
end

get '/ip' do
  content_type :text
  "#{requested_ip}\n"
end

get '/json' do
  content_type :json
  json_payload(requested_ip)
end

%w[country city isp].each do |field|
  get "/#{field}" do
    content_type :text
    "#{location_info(requested_ip)[field.to_sym]}\n"
  end
end

def location_info(remote_ip)
  return {} unless /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/.match?(remote_ip)

  record = GeoLiteReader.new('GeoLite2-City').record(remote_ip)
  location(record).merge(city(record)).merge(isp_info(remote_ip))
end

def location(record)
  return {} if record.nil?

  {
    "country": record['country']['names']['en'],
    "coordinate": {
      "latitude": record['location']['latitude'],
      "longitude": record['location']['longitude']
    }
  }
end

def city(record)
  return {} if record.nil?

  record['city'] ? { 'city': record['city']['names']['en'] } : {}
end

def isp_info(remote_ip)
  return {} unless /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/.match?(remote_ip)

  record = GeoLiteReader.new('GeoLite2-ASN').record(remote_ip)
  { "isp": record['autonomous_system_organization'] }
end

def set_lat_long
  @latitude = @location[:coordinate][:latitude]
  @longitude = @location[:coordinate][:longitude]
end
