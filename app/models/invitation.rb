class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }
  validates_associated :user
  validates_associated :event
end
