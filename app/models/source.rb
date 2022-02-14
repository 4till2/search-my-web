class Source < ApplicationRecord
  belongs_to :account
  belongs_to :page

  scope :trusted, -> { where(status: trusted) }

  enum status: { untrusted: 0, trusted: 1 }
end
