class Account < ApplicationRecord
  belongs_to :user
  has_one :profile, dependent: :destroy
  after_create_commit :build_associated

  validates_uniqueness_of :user_id
  validates_uniqueness_of :nickname
  validates :nickname, length: { minimum: 3, maximum: 15 }

  # must start and end with an alphanumeric character.
  # special characters underscore (_) and dash(-) are allowed
  validates :nickname, format: { with: /\A[a-zA-Z0-9]+([_-]?[a-zA-Z0-9])*\z/,
                                 message: 'is an invalid format. Only alphanumeric characters are allowed.' }

  private

  def build_associated
    build_profile.save! unless profile
  end

end
