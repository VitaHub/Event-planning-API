class AttachmentsController < ApplicationController
  before_action :set_event

  def index
    @attachments = @event.attachments

    render json: @attachments
  end

  def create
    @attachment = @event.attachments.new(attachment_params)

    if @attachment.save
      render json: @attachment, status: :created
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  private
    def attachment_params
      params.require(:attachment).permit(:user_id, :file)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end
end
