class Profile < ApplicationRecord
  belongs_to :account
  has_one_attached :avatar, dependent: :destroy

  validates_uniqueness_of :account_id
end
