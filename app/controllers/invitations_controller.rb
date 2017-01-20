class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_participant

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

  def invited_users
    render json: @event.invited_users
  end

  def uninvited_users
    render json: @event.uninvited_users
  end

  private
    def invitation_params
      params.require(:invitation).permit(:user_id)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end

    def check_if_participant
      uninvited_users_id = @event.uninvited_users.map { |u| u.id }
      if uninvited_users_id.include?(current_user.id)
        raise SecurityError, "Only participant can invite to the event."
      end
    end
end
