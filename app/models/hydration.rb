class Hydration < ApplicationRecord
  belongs_to :page
  after_create :refresh

  def pour(url)
    return unless url.present?

    p = Services::PageParser.new(url)
    self.title = p.title
    self.summary = p.summary
    self.author = p.author
    self.date_published = p.date_published
    self.lead_image_url = p.lead_image_url
    self.content = p.content
    self.domain = p.domain
    self.excerpt = p.excerpt
    self.word_count = p.word_count
    self.direction = p.direction
  end

  def refresh
    pour page&.url
    save
  end

end
