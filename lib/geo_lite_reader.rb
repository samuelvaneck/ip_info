# frozen_string_literal: true

class GeoLiteReader
  attr_writer :reader

  def initialize(db_name)
    db_file = File.join(File.dirname(__FILE__), "./db/#{db_name}.mmdb")
    @reader = MaxMind::DB.new(db_file, mode: MaxMind::DB::MODE_FILE)
  end

  def record(remote_ip)
    record = @reader.get(remote_ip)
    @reader.close
    record
  end
end
