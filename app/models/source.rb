class Source < ApplicationRecord
  belongs_to :account
  belongs_to :page

  validates_uniqueness_of :page_id, scope: :account

  scope :trusted, -> { where(status: trusted) }


  def self.add(page_id, account_id)
    Source.create!(account_id: account_id, page_id: page_id)
  end

  enum status: { untrusted: 0, trusted: 1 }
end
