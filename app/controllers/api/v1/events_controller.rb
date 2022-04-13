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
end