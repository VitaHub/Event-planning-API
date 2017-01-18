class InvitationsController < ApplicationController
  before_action :set_event

  def create
    @invitation = @event.invitations.new(invitation_params)

    user_id = invitation_params["user_id"].to_i
    if @event.organizer_id == user_id
      render json: { status: 500, error: "The user is the organizer of the event."}
    elsif @invitation.save
      render json: @invitation, status: :created
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  private
    def invitation_params
      params.require(:invitation).permit(:user_id)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end
end
