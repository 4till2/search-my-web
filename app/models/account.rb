class Account < ApplicationRecord
  belongs_to :user
  has_one :profile, dependent: :destroy
  has_many :sources
  # This is a source for another
  has_many :sourcers, class_name: 'Source', as: :sourceable, dependent: :destroy, inverse_of: :sourceable
  has_many :sorcerer_accounts, through: :sourcers, source: 'account'

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

  def source_label_names
    ActsAsTaggableOn::Tag.for_tenant(id)
  end

  # @param names a tag or array of tags to match
  # @param any match any of the tags. Defaults to true. False will only match all tags
  # @param exclude exclude the provided tags
  # @param wild look for %tag% as partial match
  # @return matching sources or all sources if names is empty
  def source_labels(*names, any: true, exclude: false, wild: false)
    return sources unless names

    sources.tagged_with(names.flatten, any: any, exclude: exclude, wild: wild)
  end

  private

  def build_associated
    build_profile.save! unless profile
  end

end
