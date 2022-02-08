class EventsController < ApplicationController
  def show
    @repository = params[:id]
    @events = Event.where(repository: @repository).limit(30) # TODO pagination
  end
end