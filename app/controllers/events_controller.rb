class EventsController < ApplicationController
  def show
    @repository = params[:id]
    @title = @repository

    # TODO 404 if there are no events for repo at all

    @events = Event.where(repository: @repository).order('id DESC').limit(30)

    start_time = Time.now
    @events = @events.where('created_at between ? and ?', start_time - 1.month, start_time)

    # TODO allow paging back before 1 month (maybe by year?)

    if params[:before]
      @events = @events.where('events.id < ?', params[:before]).order('id DESC')
    end
  end
end