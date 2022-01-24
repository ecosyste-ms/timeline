namespace :events do
  task last_day: :envirnoment do
    Event.download_last_day
  end
end