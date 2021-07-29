# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'maxmind/db'
require 'sinatra'
require 'erb'

Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
  @remote_ip = request.params['ip'] || request.ip
  @location = location_info(@remote_ip)
  # @isp = isp_info(@remote_ip)

  if request.accept.map(&:entry).include?('text/html')
    set_lat_long unless @location.empty?
    erb :ip, { layout: :application }
  else
    "#{JSON.pretty_generate({ "ip": @remote_ip }.merge(@location))} \n"
  end
end

def location_info(remote_ip)
  return {} unless /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/.match?(remote_ip)

  reader = MaxMind::DB.new(File.join(File.dirname(__FILE__), './db/GeoLite2-City.mmdb'), mode: MaxMind::DB::MODE_FILE)
  record = reader.get(remote_ip)
  location = if record.nil?
               puts "#{remote_id} was not found in the database"
               {}
             else
               {
                 "country": record['country']['names']['en'],
                 "coordinate": {
                   "latitude": record['location']['latitude'],
                   "longitude": record['location']['longitude']
                 }
               }.merge(city(record)).merge(isp_info(remote_ip))
             end
  reader.close

  location
end

def isp_info(remote_ip)
  return {} unless /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/.match?(remote_ip)

  reader = MaxMind::DB.new(File.join(File.dirname(__FILE__), './db/GeoLite2-ASN.mmdb'), mode: MaxMind::DB::MODE_FILE)
  record = reader.get(remote_ip)
  { "isp": record['autonomous_system_organization'] }
end

def set_lat_long
  @latitude = @location[:coordinate][:latitude]
  @longitude = @location[:coordinate][:longitude]
end

def city(record)
  record['city'] ? { 'city': record['city']['names']['en'] } : {}
end
