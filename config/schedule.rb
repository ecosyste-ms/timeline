job_type :rbenv_rake, %Q{export PATH=/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
  cd :path && RAILS_ENV=production bundle exec rake :task --silent :output }

every 1.hour do
  rbenv_rake "events:last_day"
end