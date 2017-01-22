class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_participant

  def index
    @comments = @event.comments.order("created_at ASC")
    
    render json: @comments
  end

  def create
    @comment = @event.comments.new(comment_params.merge(user_id: current_user.id))

    if @comment.save
      @comment.create_activity :create, owner: current_user, 
        event_id: @event.id, recipient: @comment
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text)
    end

    def set_event
      @event = Event.find(params[:event_id])
    end

    def check_if_participant
      unless @event.participants_ids.include?(current_user.id)
        raise SecurityError, "Only participant of event can create 
          comment or get the list of comments."
      end
    end
end
