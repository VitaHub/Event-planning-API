class Event < ApplicationRecord
  include PublicActivity::Common

  belongs_to :organizer, class_name: "User"
  has_many :invitations
  has_many :invited_users, through: :invitations, source: :user 
  has_many :comments
  has_many :attachments

  validates :description, length: { maximum: 500 }
  validates_datetime :time, :after => lambda { DateTime.now }

  scope :by_participant_and_params, (lambda do |participant_id, params|
    query = event_participants_query
    query << " AND time < '#{params[:due].to_datetime.to_s(:db)}'" if 
      params[:due]
    if params[:interval]
      due_date = DateTime.now + params[:interval][0..-2].to_i.days
      query << " AND time < '#{due_date.to_s(:db)}'"
    end
    if params[:time]
      query << " AND time < '#{DateTime.now.to_s(:db)}'" if 
        params[:time] == "past"
      query << " AND time > '#{DateTime.now.to_s(:db)}'" if 
        params[:time] == "future"
    end

    find_by_sql([query + " ORDER BY time ASC", participant_id, participant_id])
  end)

  def participants_ids
    participants_ids = invited_users.map { |u| u.id }
    participants_ids << organizer_id
  end

  def uninvited_users
    User.where.not(id: participants_ids)
  end

  private

    def self.event_participants_query
      "
      SELECT DISTINCT events.id, events.name, events.organizer_id, 
        events.time, events.place, events.description
      FROM events 
      LEFT OUTER JOIN invitations ON invitations.event_id = events.id 
      WHERE 
        (invitations.user_id = ? OR organizer_id = ?)
      "
    end
end
