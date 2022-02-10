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

    begin
      gz =  URI.open(url)
      Event.import_batch(gz, filename)
    rescue OpenURI::HTTPError => error
      response = error.io
      puts response.status
    end
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
    gz.close unless gz.nil? or gz.closed?
    File.delete(filepath) if File.exist?(filepath)
  end

  def self.import_batch(gz, filename)
    starts = Time.now
    js = Zlib::GzipReader.new(gz).read
    batch_size = 2000
    events = []
    count = 0
    begin
      Oj.load(js) do |event_json|
        events << Event.format_event(event_json)
        if events.length >= batch_size
          count += 1
          Event.insert_all(events) if events.any?
          events = []
        end
      end
      count = (count*batch_size) + events.length
      Event.insert_all(events) if events.any?
      ends = Time.now
      puts "Finished: #{ends - starts} seconds"
      Import.create(filename: filename, event_count: count)
    rescue Oj::ParseError
      puts "Invalid JSON in #{filename}"
    end
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

  def self.download_last_day
    start_time = 1.day.ago
    end_time = Time.now
    hours = []
    
    while start_time <= end_time
      hours.push({year: start_time.year, month: start_time.month, day: start_time.day, hour: start_time.hour})
      start_time += 1.hour
    end

    urls = hours.map do |hour|
      "https://data.gharchive.org/#{hour[:year]}-#{hour[:month].to_s.rjust(2, "0")}-#{hour[:day].to_s.rjust(2, "0")}-#{hour[:hour]}.json.gz"
    end

    urls.each do |url|
      import_from_url(url)
    end
  end

  def title
    "#{actor} #{action_text} #{repository.full_name}"
  end

  def html_url
    case event_type
    when 'WatchEvent'
      "https://github.com/#{repository.full_name}/stargazers"
    when "CreateEvent"
      "https://github.com/#{repository.full_name}/tree/#{payload['ref']}"
    when "CommitCommentEvent"
      payload['comment']['html_url']
    when "ReleaseEvent"
      payload['release']['html_url']
    when "IssuesEvent"
      payload['issue']['html_url']
    when "DeleteEvent"
      "https://github.com/#{repository.full_name}"
    when "IssueCommentEvent"
      payload['comment']['html_url']
    when "PublicEvent"
      "https://github.com/#{repository.full_name}"
    when "PushEvent"
      "https://github.com/#{repository.full_name}/commits/#{payload['ref'].gsub("refs/heads/", '')}"
    when "PullRequestReviewCommentEvent"
      payload['comment']['html_url']
    when "PullRequestReviewEvent"
      payload['review']['html_url']
    when "PullRequestEvent"
      payload['pull_request']['html_url']
    when "ForkEvent"
      payload['forkee']['html_url']
    when 'MemberEvent'
      "https://github.com/#{payload['member']['login']}"
    when 'GollumEvent'
      payload['pages'].first['html_url']
    end
  end

  def action_text
    case event_type
    when 'WatchEvent'
      'starred'
    when "CreateEvent"
      if payload['ref_type'] == 'repository'
        "created a #{payload['ref_type']}: "
      else
        "created a #{payload['ref_type']} on"
      end
    when "CommitCommentEvent"
      'commented on a commit on'
    when "ReleaseEvent"
      "#{payload['action']} a release on"
    when "IssuesEvent"
      "#{payload['action']} an issue on"
    when "DeleteEvent"
      "deleted a #{payload['ref_type']}"
    when "IssueCommentEvent"
      if payload['issue']['pull_request'].present?
        "#{payload['action']} a comment on a pull request on"
      else
        "#{payload['action']} a comment on an issue on"
      end
    when "PublicEvent"
      'open sourced'
    when "PushEvent"
      "pushed #{ActionController::Base.helpers.pluralize(payload['size'], 'commit')} to #{payload['ref'].gsub("refs/heads/", '')}"
    when "PullRequestReviewCommentEvent"
      "#{payload['action']} a review comment on a pull request on"
    when "PullRequestReviewEvent"
      "#{payload['action']} a review on a pull request on"
    when "PullRequestEvent"
      if payload['pull_request']['draft']
        "#{payload['action']} a draft pull request on"
      else
        "#{payload['action']} a pull request on"
      end
    when "ForkEvent"
      'forked'
    when 'MemberEvent'
      "#{payload['action']} #{payload['member']['login']} to"
    when 'GollumEvent'
      "#{payload['pages'].first['action']} a wiki page on"
    end
  end
end
