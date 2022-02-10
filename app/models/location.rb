class Location < ApplicationRecord
  belongs_to :word
  belongs_to :page
end
