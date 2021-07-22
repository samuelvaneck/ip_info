# frozen_string_literal: true

require 'json'
require 'maxmind/db'
require 'sinatra'

get '/' do
  location = ip_location_info(request.ip)
  { "ip": request.ip }.merge(location).to_json
end


def ip_location_info(remote_ip)
  reader = MaxMind::DB.new(File.join(File.dirname(__FILE__), './db/GeoLite2-City.mmdb'), mode: MaxMind::DB::MODE_FILE)

  record = reader.get(remote_ip.to_s)
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
