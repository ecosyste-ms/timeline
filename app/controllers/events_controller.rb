class EventsController < ApplicationController
  def show
    @repository = params[:id]
    @events = Event.where(repository: @repository).order('id DESC').limit(100) # TODO pagination
  end
end