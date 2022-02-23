class Source < ApplicationRecord
  TRUSTED = 1
  belongs_to :account
  belongs_to :sourceable, polymorphic: true
  acts_as_taggable_on :labels
  acts_as_taggable_tenant :account_id
  validates_uniqueness_of :sourceable_id, scope: %i[account sourceable_type]
  validates :sourceable_type, inclusion: { in: %w[Account Page] }
  validates :rank, presence: true
  scope :trusted, -> { where('rank >= ?', TRUSTED) }
  scope :pages, -> { where(sourceable_type: 'Page') }
  scope :accounts, -> { where(sourceable_type: 'Account') }

end
