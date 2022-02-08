class ImportsController < ApplicationController
  def index
    @imports = Import.order('created_at DESC').limit(24*7).map{|i| [i.datetime, i.event_count]}
  end
end