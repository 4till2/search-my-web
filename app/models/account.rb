class Account < ApplicationRecord
  belongs_to :user
  has_one :profile, dependent: :destroy
  has_many :sources

  after_create_commit :build_associated

  validates_uniqueness_of :user_id
  validates :nickname,
            uniqueness: {
              # object = person object being validated
              # data = { model: "User", attribute: "Username", value: <username> }
              message: lambda do |object, data|
                "#{data[:value]} is already taken."
              end
            }
  validates :nickname, presence: { message: "must be given please." }
  validates :nickname, length: { minimum: 4, maximum: 12, message: 'must be between 4 and 12 characters.' }
  validates :nickname, format: { with: /\A\w+\Z/, message: "can only contain letters, numbers and underscores." }

  private

  def build_associated
    build_profile.save! unless profile
  end

end
