class EventsController < ApplicationController
  def show
    @repository = params[:id]
    @title = @repository

    first_event = Event.where(repository: @repository).first
    raise ActiveRecord::RecordNotFound if first_event.nil?

    @events = Event.where(repository: @repository).order('id DESC').limit(30)

    @year = DateTime.parse("#{params[:year]}/1/1") rescue Time.now.year
    start_time = @year.beginning_of_year
    end_time = @year.end_of_year

    @events = @events.where('created_at between ? and ?', start_time, end_time)

    if params[:before]
      @events = @events.where('events.id < ?', params[:before]).order('id DESC')
    end
  end
end