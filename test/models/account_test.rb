require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
    @user = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    @user2 = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
  end
  test 'create account' do
    assert User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                        account_attributes: { nickname: SecureRandom.alphanumeric(10) }
  end

  test 'invalid account - user has account' do
    assert_raises(ActiveRecord::RecordInvalid, 'user_id not unique') do
      Account.create!(user: users(:one), nickname: SecureRandom.alphanumeric(6))
    end
  end

  test 'invalid account - nickname invalid ' do
    assert_raises(ActiveRecord::RecordInvalid, 'nickname too short') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                          account_attributes: { nickname: SecureRandom.alphanumeric(2) }
    end

    assert_raises(ActiveRecord::RecordInvalid, 'nickname too long') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                   account_attributes: { nickname: SecureRandom.alphanumeric(16) }
    end

    assert_raises(ActiveRecord::RecordInvalid, 'nickname bad characters') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                   account_attributes: { nickname: '_abadnickname' }
    end
    assert_raises(ActiveRecord::RecordInvalid, 'nickname bad characters') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                   account_attributes: { nickname: 'abadnic/kname' }
    end
    assert_raises(ActiveRecord::RecordInvalid, 'nickname bad characters') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                   account_attributes: { nickname: 'badnic.kname' }
    end
    assert_raises(ActiveRecord::RecordInvalid, 'nickname bad characters') do
      User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                   account_attributes: { nickname: 'abadni ckname' }
    end
  end

  test 'invalid account - duplicate nickname' do
    u = SecureRandom.alphanumeric(10)
    assert User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                        account_attributes: { nickname: u }
    assert_raises(ActiveRecord::RecordInvalid, 'nickname not unique') do
      assert User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                          account_attributes: { nickname: u }
    end
  end
end
