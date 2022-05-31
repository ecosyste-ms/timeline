class Api::V1::EventsController < Api::V1::ApplicationController
  def index
    @pagy, @events = pagy(Event.order('id DESC'))
  end

  def show
    @repository = params[:id]
    first_event = Event.where(repository: @repository).first
    raise ActiveRecord::RecordNotFound if first_event.nil?

    @pagy, @events = pagy_countless(Event.where(repository: @repository).order('id DESC'))
  end

  def repository_names
    events = Event.order('id DESC').limit(10000).select(:id, :created_at, :repository)

    if params[:before]
      events = events.where('events.id < ?', params[:before])
    end

    if params[:after]
      events = events.where('events.id > ?', params[:after])
    end

    @names = events.map(&:repository).uniq
    @newest = events.first
    @oldest = events.last
  end
end