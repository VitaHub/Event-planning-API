class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_participant

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

    def check_if_participant
      uninvited_users_id = @event.uninvited_users.map { |u| u.id }
      if uninvited_users_id.include?(current_user.id)
        raise SecurityError, "Only participant of event can create 
          comment or get the list of comments."
      end
    end
end
