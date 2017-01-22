class Comment < ApplicationRecord
  include PublicActivity::Common
  
  belongs_to :user
  belongs_to :event

  validates :text, presence: true
end
