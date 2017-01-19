class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"
  has_many :invitations
  has_many :invited_users, through: :invitations, source: :user 
  has_many :comments
  has_many :attachments

  validates :description, length: { maximum: 500 }
  validates_datetime :time, :after => lambda { DateTime.now }

  scope :in_future, (lambda do
    where("time > ?", DateTime.now)
  end)

  scope :by_interval, (lambda do |interval|
    due_date = DateTime.now + interval[0..-2].to_i.days
    where("time < ?", due_date)
  end)

  scope :due_date, (lambda do |due_date|
    where("time < ?", due_date)
  end)

  def uninvited_users
    User.find_by_sql(["SELECT DISTINCT users.id, users.name 
      FROM users
      LEFT OUTER JOIN invitations ON invitations.user_id = users.id 
      WHERE 
        (NOT invitations.event_id = ? OR invitations.event_id IS NULL) 
      AND 
        NOT users.id = ?", id, organizer.id])
  end
end
