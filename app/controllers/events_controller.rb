class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :check_if_organizer, only: [:update, :destroy]
  before_action :check_if_participant, only: :show

  def index
    @events = Event.by_participant_and_params(current_user.id, params)

    render json: @events
  end

  def show
    render json: @event
  end

  def create
    @event = current_user.own_events.new(event_params)

    if @event.save
      @event.create_activity :create, owner: current_user, 
        event_id: @event.id, recipient: @event
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      @event.create_activity :update, owner: current_user, 
        event_id: @event.id, recipient: @event
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    event_id = @event.id
    parameters = { event: {
      name: @event.name, 
      time: @event.time, 
      place: @event.place 
    }}
    @event.destroy
    current_user.create_activity :destroy, owner: current_user, 
      event_id: event_id, parameters: parameters, key: "event.destroy"
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :time, :place, :description)
    end

    def check_if_organizer
      unless current_user.id == @event.organizer_id
        raise SecurityError, "Only organizer can update or destroy own events."
      end
    end

    def check_if_participant
      unless @event.participants_ids.include?(current_user.id)
        raise SecurityError, "Only participant can get the event."
      end
    end
end
