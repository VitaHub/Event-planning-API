class CommentsController < ApplicationController
  before_action :set_event

  def index
    @comments = @event.comments.order("created_at ASC")
    render json: @comments
  end

  def create
    @comment = @event.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :user_id)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end
end
