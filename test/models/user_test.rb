require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @valid_password = 'Asdfghjk!2'
    @invalid_password = 'sdfghj'
  end
  test 'create user' do
    assert User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @valid_password, password_confirmation: @valid_password, account_attributes: { nickname: SecureRandom.alphanumeric(10) }

  end

  test 'invalid user - short password' do
    assert_raises(ActiveRecord::RecordInvalid, 'Should raise - Validateion faild: password too short') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @invalid_password, password_confirmation: @invalid_password, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    end
  end

  test 'invalid user - non unique email' do
    email = "#{SecureRandom.alphanumeric(10)}@mail.com"
    User.create! email: email, password: @valid_password, password_confirmation: @valid_password, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    assert_raises(ActiveRecord::RecordInvalid) do
      User.create! email: email, password: @valid_password, password_confirmation: @valid_password, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    end
  end
  test 'invalid user - requires password' do
    assert_raises(ActiveRecord::RecordInvalid, "Should raise - Validation failed:  Password can't be blank") do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    end
  end
  test 'invalid user - requires password confirmation' do
    assert_raises(ActiveRecord::RecordInvalid, 'Should raise - Validation failed: password confirmation cant be blank') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @valid_password,
                   account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    end
  end
  test 'invalid user - wrong password confirmation' do
    assert_raises(ActiveRecord::RecordInvalid, 'Should raise - Validation failed: password confirmation must match') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @valid_password, password_confirmation: @invalid_password, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    end
  end
end