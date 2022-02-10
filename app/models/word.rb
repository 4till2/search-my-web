class Word < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :pages, through: :locations

end
