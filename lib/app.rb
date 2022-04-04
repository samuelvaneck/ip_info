# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'maxmind/db'
require 'sinatra'
require 'erb'
require_relative 'geo_lite_reader'

Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
  @remote_ip = request.params['ip'] || request.ip
  @location = location_info(@remote_ip)

  if request.accept.map(&:entry).include?('text/html')
    set_lat_long unless @location.empty?
    erb :ip, { layout: :application }
  else
    "#{JSON.pretty_generate({ "ip": @remote_ip }.merge(@location))} \n"
  end
rescue StandardError => e
  puts request.inpsect
  puts ' '
  puts "🚑 Whambulance because of #{e.message}"
  puts ' '
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
