FRESHNESS_POLICY = 60 * 60 * 24 * 7 # 7 days

class Page < ApplicationRecord
  has_one :hydration, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :words, through: :locations
  has_many :sources, dependent: :destroy
  validates :url, presence: true
  validates_uniqueness_of :url

  # after_create_commit :build_associated

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
