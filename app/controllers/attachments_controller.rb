class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_participant

  def index
    @attachments = @event.attachments

    render json: @attachments
  end

  def create
    @attachment = @event.attachments.new(attachment_params.merge(user_id: 
      current_user.id))

    if @attachment.save
      @attachment.create_activity :create, owner: current_user, 
        event_id: @event.id, recipient: @attachment
      render json: @attachment, status: :created
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  private
    def attachment_params
      params.require(:attachment).permit(:file)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end

    def check_if_participant
      unless @event.participants_ids.include?(current_user.id)
        raise SecurityError, "Only participant of event can create 
          or get attachment."
      end
    end
end
