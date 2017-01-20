class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_many :own_events, class_name: "Event", foreign_key: "organizer_id"
  has_many :invitations
  has_many :events, through: :invitations

  def events_in_which_participant
    Event.find_by_sql(["SELECT DISTINCT events.id, events.name, events.organizer_id, 
        events.time, events.place, events.description
      FROM events 
      LEFT OUTER JOIN invitations ON invitations.event_id = events.id 
      WHERE invitations.user_id = ? OR organizer_id = ?", id, id])
  end
end
