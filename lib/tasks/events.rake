namespace :events do
  desc 'Download gh events for the past 24 hours'
  task last_day: :environment do
    Event.download_last_day
  end
end