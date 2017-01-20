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
      params.require(:event).permit(:name, :time, :place, :description)
    end

    def check_if_organizer
      unless current_user.id == @event.organizer_id
        raise SecurityError, "Only organizer can update or destroy own events."
      end
    end

    def check_if_participant
      uninvited_users_id = @event.uninvited_users.map { |u| u.id }
      if uninvited_users_id.include?(current_user.id)
        raise SecurityError, "Only participant can get the event."
      end
    end
end
