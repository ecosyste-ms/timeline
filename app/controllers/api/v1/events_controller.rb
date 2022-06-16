class Api::V1::EventsController < Api::V1::ApplicationController
  def index
    @scope = Event.order('id DESC')
    @scope = @scope.where(event_type: params[:event_type]) if params[:event_type].present?

    @pagy, @events = pagy_countless(@scope)
  end

  def show
    @repository = params[:id]
    first_event = Event.where(repository: @repository).first
    raise ActiveRecord::RecordNotFound if first_event.nil?

    @scope = Event.where(repository: @repository).order('id DESC')
    @scope = @scope.where(event_type: params[:event_type]) if params[:event_type].present?

    @pagy, @events = pagy_countless(@scope)
  end

  def repository_names
    events = Event.order('id DESC').limit(10000).select(:id, :created_at, :repository)

    if params[:before].present?
      events = events.where('events.id < ?', params[:before])
    end

    if params[:after].present?
      events = events.where('events.id > ?', params[:after])
    end

    @names = events.map(&:repository).uniq
    @newest = events.first
    @oldest = events.last
  end
end