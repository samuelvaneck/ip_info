# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'maxmind/db'
require 'sinatra'
require 'erb'

Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
  @remote_ip = request.params['ip'] || request.ip
  @location = ip_location_info(@remote_ip)

  if request.accept.map(&:entry).include?('text/html')
    set_lat_long unless @location.empty?
    erb :ip, { layout: :application }
  else
    { "ip": @remote_ip }.merge(@location).to_json
  end
end

def ip_location_info(remote_ip)
  reader = MaxMind::DB.new(File.join(File.dirname(__FILE__), './db/GeoLite2-City.mmdb'), mode: MaxMind::DB::MODE_FILE)
  return {} unless /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/.match?(remote_ip)

  record = reader.get(remote_ip)
  location = if record.nil?
               puts "#{remote_id} was not found in the database"
               {}
             else
               {
                 "country": record['country']['names']['en'],
                 "city": record['city']['names']['en'],
                 "coordinate": {
                   "latitude": record['location']['latitude'],
                   "longitude": record['location']['longitude']
                 }
               }
             end
  reader.close

  location
end

def set_lat_long
  @latitude = @location[:coordinate][:latitude]
  @longitude = @location[:coordinate][:longitude]
end
