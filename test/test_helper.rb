ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  @@pswd = 'Asdfjkl;1@'
  def create_user_with_account
    User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
  end

  module SignInHelper
    def sign_in_as(user)
      sign_in(user)
      # post new_user_session_path(email: user.email, password: 'Asdfjkl;1@')
    end

    def sign_out_user
      sign_out :user
      # delete destroy_user_session_path
    end
  end

  class ActionDispatch::IntegrationTest
    include SignInHelper

  end

end
