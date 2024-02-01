class Profile < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  mount_uploader :background, BackgroundUploader

  belongs_to :user
end
