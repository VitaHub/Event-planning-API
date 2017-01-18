class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    @events = Event.order("time ASC")
    @events = @events.by_interval(params[:interval]) if params[:interval]
    @events = @events.due_date(params[:due]) if params[:due]
    render json: @events
  end

  def show
    render json: @event
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :organizer_id, :time, 
        :place, :description)
    end
end
