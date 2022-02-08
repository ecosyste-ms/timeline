class EventsController < ApplicationController
  def show
    @repository = params[:id]
    @title = @repository
    @events = Event.where(repository: @repository).order('id DESC').limit(30)
    if params[:before]
      @events = @events.where('events.id < ?', params[:before]).order('id DESC')
    end
  end
end