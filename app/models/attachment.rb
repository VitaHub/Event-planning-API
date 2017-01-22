class Attachment < ApplicationRecord
  include PublicActivity::Common
  
  belongs_to :user
  belongs_to :event

  mount_base64_uploader :file, FileUploader
end
