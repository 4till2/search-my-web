require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    user = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd,
                        account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    @account = user.account
  end

  test 'automatic create profile' do
    assert @account.profile.present?
  end

  test 'invalid profile - account already has a profile ' do
    assert_raises(ActiveRecord::RecordInvalid, 'account already with profile') do
      Profile.create!(account: accounts(:one))
    end
  end
end
