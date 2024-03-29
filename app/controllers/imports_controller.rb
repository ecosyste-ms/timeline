class ImportsController < ApplicationController
  def index
    @imports = Import.order('created_at DESC').limit(24*14).map{|i| [i.datetime, i.event_count]}
    @events = Event.order('id DESC').limit(10).to_a.sort_by(&:created_at).reverse
    expires_in 1.hour, public: true
  end
end