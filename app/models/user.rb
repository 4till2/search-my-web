# frozen_string_literal: true
class User < ApplicationRecord
  STRICT_PASSWORD_FORMAT = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x

  LENIENT_PASSWORD_FORMAT = /\A
  (?=.{8,})          # Must contain 8 or more characters
/x
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account, dependent: :destroy
  has_one :profile, through: :account

  accepts_nested_attributes_for :account

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
  validates :password, presence: true, format: { with: LENIENT_PASSWORD_FORMAT }
  validates_comparison_of :password, equal_to: :password_confirmation, message: 'confirmation incorrect'
  validates :account, presence: { value: true, message: 'nickname missing' }

end
