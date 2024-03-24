class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  after_action lambda {
    request.session_options[:skip] = true
  }
end
