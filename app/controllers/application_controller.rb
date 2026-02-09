class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_cache_headers

  after_action lambda {
    request.session_options[:skip] = true
  }

  def set_cache_headers(browser_ttl: 5.minutes, cdn_ttl: 6.hours)
    return unless request.get?
    response.cache_control.merge!(
      public: true,
      max_age: browser_ttl.to_i,
      stale_while_revalidate: cdn_ttl.to_i,
      stale_if_error: 1.day.to_i
    )
    response.cache_control[:extras] = ["s-maxage=#{cdn_ttl.to_i}"]
  end
end
