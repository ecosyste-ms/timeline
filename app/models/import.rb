class Import < ApplicationRecord
  def url
    "http://data.gharchive.org/#{filename}"
  end

  def self.url_for(datetime)
    "http://data.gharchive.org/#{datetime.year}-#{datetime.month}-#{datetime.day}-#{datetime.hour}.json.gz"
  end

  def datetime
    DateTime.new(*filename.split('.').first.split('-').map(&:to_i))
  end
end
