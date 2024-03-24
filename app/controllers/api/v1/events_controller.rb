class Api::V1::EventsController < Api::V1::ApplicationController
  def index
    @scope = Event.order('id DESC')
    @scope = @scope.where(event_type: params[:event_type]) if params[:event_type].present?

    if params[:before].present?
      @scope = @scope.where('events.id < ?', params[:before])
    end

    if params[:after].present?
      @scope = @scope.where('events.id > ?', params[:after])
    end

    @pagy, @events = pagy_countless(@scope)
    expires_in 1.hour, public: true
  end

  def show
    @repository = params[:id]
    first_event = Event.where(repository: @repository).first
    raise ActiveRecord::RecordNotFound if first_event.nil?

    @scope = Event.where(repository: @repository).order('id DESC')
    @scope = @scope.where(event_type: params[:event_type]) if params[:event_type].present?

    if params[:before].present?
      @scope = @scope.where('events.id < ?', params[:before])
    end

    if params[:after].present?
      @scope = @scope.where('events.id > ?', params[:after])
    end

    @pagy, @events = pagy_countless(@scope)
    expires_in 1.hour, public: true
  end

  def summary
    @repository = params[:id]
    @scope = Event.where(repository: @repository)

    if params[:year]
      @year = DateTime.parse("#{params[:year]}/1/1") rescue Time.now.year
      @title = @repository + " Events in #{@year.year} - Ecosyste.ms: Timeline"
      start_time = @year.beginning_of_year
      end_time = @year.end_of_year
      @scope = @scope.where('created_at between ? and ?', start_time, end_time)
    end

    if params[:before].present?
      @scope = @scope.where('events.created_at < ?', params[:before])
    end

    if params[:after].present?
      @scope = @scope.where('events.created_at > ?', params[:after])
    end

    render json: @scope.group(:event_type).count
    expires_in 1.day, public: true
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
    expires_in 1.hour, public: true
  end
end