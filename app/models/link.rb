class Link < ApplicationRecord
  belongs_to :origin, class_name: 'Page'
  belongs_to :destination, class_name: 'Page'

  validates_uniqueness_of :origin_id, scope: :destination_id
  validates_comparison_of :origin_id, other_than: :destination_id

  def self.add_with_url(origin_url, destination_url)
    return unless origin_url.present? && destination_url.present?

    origin = Page.find_or_create_by(url: origin_url)
    destination = Page.find_or_create_by(url: destination_url)
    Link.create(origin: origin, destination: destination) if origin.save && destination.save
  end
end
