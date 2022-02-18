class Page < ApplicationRecord
  FRESHNESS_POLICY = 60 * 60 * 24 * 7 # 7 days
  has_one :hydration, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :words, through: :locations
  # This page is a source for another
  has_many :sourcers, class_name: 'Source', as: :sourceable
  has_many :sorcerer_accounts, through: :sourcers, source: 'account'

  # Get links where this page is the origin
  has_many :links_as_origin, class_name: 'Link', foreign_key: 'origin_id', inverse_of: 'origin'
  # Get links where this page is the destination
  has_many :links_as_destination, class_name: 'Link', foreign_key: 'destination_id', inverse_of: 'destination'

  # Get pages referencing this page
  has_many :origin_pages, through: :links_as_destination, class_name: 'Page', source: 'origin'
  # Get pages referenced by this page
  has_many :destination_pages, through: :links_as_origin, class_name: 'Page', source: 'destination'

  validates :url, presence: true
  validates_uniqueness_of :url

  def self.find_or_create(url)
    page = find_by(url: url)
    page = new(url: url) if page.nil?
    page
  end

  def refresh
    hydrate
    touch
  end

  def age
    return nil unless last_indexed

    (Time.now - last_indexed&.to_time) / 60
  end

  def fresh?
    age && age <= FRESHNESS_POLICY
  end

  def hydrate
    if hydration.present?
      hydration.refresh
    elsif id
      self.hydration = Hydration.create(page: self)
    else
      raise StandardError, 'Save page before hydrating.'
    end
  end

  private

  def build_associated
    hydrate unless hydration.present?
  end

end
