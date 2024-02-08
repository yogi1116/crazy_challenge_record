class Profile < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  mount_uploader :background, BackgroundUploader

  belongs_to :user
  accepts_nested_attributes_for :user
end
