class Event < ApplicationRecord
  def self.import_from_folder(folder_path)
    starts = Time.now
    Dir["#{folder_path}/*.json.gz"].each do |path|
      puts "Importing #{path}"
      Event.import_from_file(path)
    end
    ends = Time.now
    puts "Finished all: #{ends - starts} seconds"
  end

  def self.import_from_url(url)
    filename = url.split('/').last
    i = Import.find_by_filename(filename)
    if i
      puts "Already imported #{i.event_count} from #{filename}"
      return 
    end

    gz =  URI.open(url)
    Event.import_batch(gz, filename)
  end

  def self.import_from_file(filepath)
    filename = filepath.split('/').last
    i = Import.find_by_filename(filename)
    if i
      puts "Already imported #{i.event_count} from #{filename}"
      return 
    end
    gz =  File.open(filepath)
    Event.import_batch(gz, filename)
  end

  def self.import_batch(gz, filename)
    starts = Time.now
    js = Zlib::GzipReader.new(gz).read
    batch_size = 2000
    events = []
    count = 0
    Oj.load(js) do |event_json|
      events << Event.format_event(event_json)
      if events.length >= batch_size
        count += 1
        Event.insert_all(events)
        events = []
      end
    end
    count = (count*batch_size) + events.length
    Event.insert_all(events)
    ends = Time.now
    puts "Finished: #{ends - starts} seconds"
    Import.create(filename: filename, event_count: count)
  end

  def self.format_event(event_json)
    {
      id: event_json['id'],
      actor: event_json['actor']['login'],
      event_type: event_json['type'],
      repository: event_json['repo']['name'],
      owner: event_json['repo']['name'].split('/')[0],
      payload: event_json['payload'],
      created_at: event_json['created_at']
    }
  end
end
