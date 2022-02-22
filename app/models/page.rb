class Page < ApplicationRecord
  include PgSearch::Model
  include LinkHelpers

  FRESHNESS_POLICY = 60 * 60 * 24 * 7 # 7 days
  # This page is a source for another
  has_many :sourcers, class_name: 'Source', as: :sourceable, dependent: :destroy, inverse_of: :sourceable
  has_many :sourcer_accounts, through: :sourcers, source: 'account'

  # Get links where this page is the origin
  has_many :links_as_origin, class_name: 'Link', foreign_key: 'origin_id', inverse_of: 'origin', dependent: :destroy
  # Get links where this page is the destination
  has_many :links_as_destination, class_name: 'Link', foreign_key: 'destination_id', inverse_of: 'destination', dependent: :destroy

  # Get pages referencing this page
  has_many :origin_pages, through: :links_as_destination, class_name: 'Page', source: 'origin'
  # Get pages referenced by this page
  has_many :destination_pages, through: :links_as_origin, class_name: 'Page', source: 'destination'

  validates :url, presence: true
  validate do
    errors.add(:base, 'Url is invalid') unless url&.valid_url?
  end
  validates_uniqueness_of :url

  before_save :strip_params

  scope :hydrated, -> { where.not(last_indexed: nil) }

  pg_search_scope :search,
                  against: { url: 'A', title: 'A', summary: 'B', content: 'C' },
                  using: {
                    tsearch: {
                      dictionary: 'english', tsvector_column: 'searchable'
                    }
                  }

  pg_search_scope :search_by, lambda { |page_part, query, *options|
    raise ArgumentError unless %i[url title content author].include?(page_part)

    {
      against: page_part,
      query: query
    }
  }

  @raw_html = nil

  def age
    return nil unless last_indexed

    (Time.now - last_indexed&.to_time) / 60
  end

  def fresh?
    age && age <= FRESHNESS_POLICY
  end

  def stale?
    !fresh?
  end

  def hydrate(force = false)
    return if fresh? && !force

    self.last_indexed = DateTime.now if pour
    save
  end

  # @note to be chained after hydrate only
  def build_links
    return unless @raw_html

    Nokogiri::HTML(@raw_html)&.css('a')&.map do |link|
      href = link['href']
      Link.add_with_url(url, link['href']) unless href.include?(domain) # Dont link to same domain
    end
  end

  def hydrate_async(force = false)
    HydrationJob.perform_async(id, force)
  end

  private

  def pour
    return unless url.present?

    p = Services::PageParser.new(url)
    self.title = p.title
    self.summary = p.summary
    self.author = p.author
    self.date_published = p.date_published
    self.lead_image_url = p.lead_image_url
    self.content = Formatters::Html.clean_text(p.content)
    self.domain = p.domain
    self.excerpt = p.excerpt
    self.word_count = p.word_count
    self.direction = p.direction

    @raw_html = p.content
  end

  # @todo: get rid of www.
  def strip_params
    self.url = url.split('?').first
  end

end
