class Source < ApplicationRecord
  TRUSTED = 1
  belongs_to :account
  belongs_to :sourceable, polymorphic: true
  validates_uniqueness_of :sourceable_id, scope: %i[account sourceable_type]
  validates :sourceable_type, inclusion: { in: %w[Account Page] }
  validates :rank, presence: true
  scope :trusted, -> { where("rank >= ?", TRUSTED) }

end
