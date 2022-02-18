class Link < ApplicationRecord
  belongs_to :origin, class_name: 'Page'
  belongs_to :destination, class_name: 'Page'
end
