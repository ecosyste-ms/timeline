namespace :events do
  task last_day: :environment do
    Event.download_last_day
  end
end