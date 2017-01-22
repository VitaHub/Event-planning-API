class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    events_ids = current_user.events_in_which_participant.map { |e| e.id }
    @activities = PublicActivity::Activity.where("event_id IN (?) AND NOT owner_id = ?", events_ids, current_user.id).order("created_at DESC")

    render json: @activities
  end
end