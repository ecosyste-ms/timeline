class EventsController < ApplicationController
  def index
    redirect_to event_path(params[:id]) if params[:id].present?

    @title = "Recent #{params[:event_type].try(:titleize) || 'Event'}s - Ecosyste.ms: Timeline"
    @scope = Event.order('id DESC').limit(30)
    @scope = @scope.where(event_type: params[:event_type]) if params[:event_type].present?

    if params[:before].present?
      @scope = @scope.where('events.id < ?', params[:before])
    end

    if params[:after].present?
      @scope = @scope.where('events.id > ?', params[:after])
    end

    @events = @scope.order('id DESC')
  end

  def show
    @repository = params[:id]
    
    first_event = Event.where(repository: @repository).first
    raise ActiveRecord::RecordNotFound if first_event.nil?

    @events = Event.where(repository: @repository).order('id DESC').limit(30)

    @year = DateTime.parse("#{params[:year]}/1/1") rescue Time.now.year
    @title = @repository + " Events in #{@year.year} - Ecosyste.ms: Timeline"
    start_time = @year.beginning_of_year
    end_time = @year.end_of_year

    @events = @events.where(event_type: params[:event_type]) if params[:event_type].present?

    @events = @events.where('created_at between ? and ?', start_time, end_time)

    if params[:before]
      @events = @events.where('events.id < ?', params[:before]).order('id DESC')
    end
  end
end