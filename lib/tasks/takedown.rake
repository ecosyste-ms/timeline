namespace :takedown do
  desc "Hide a user without rewriting stored events. LOGIN=username"
  task hide_user: :environment do
    login = ENV['LOGIN']
    abort "LOGIN is required" if login.blank?

    hidden_user = HiddenUser.find_or_create_by!(login: login.downcase)
    puts "[timeline] hidden user #{hidden_user.login}; stored events were not modified"
  end

  desc "Report whether a user is hidden. LOGIN=username"
  task report: :environment do
    login = ENV['LOGIN']
    abort "LOGIN is required" if login.blank?

    state = HiddenUser.hidden?(login) ? 'hidden' : 'visible'
    puts "[timeline] #{login}: user=#{state}; stored events are preserved"
  end
end
