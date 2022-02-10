require 'test_helper'

class ProfilePolicyTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_user_with_account
    @account = @owner.account
    @profile = @account.profile
    @guest = create_user_with_account
    @stranger = create_user_with_account
    sign_in_as(@guest)
  end

  def test_scope
  end

  def test_show
    #private
    get profile_url(@profile)
    assert_redirected_to root_path

    sign_in_as(@stranger)
    get profile_url(@profile)
    assert_redirected_to root_path
  end

  def test_update
    patch profile_url(@profile), params: { profile: { profile_id: @profile.id, title: 'Julies' } }
    assert_redirected_to root_path

    sign_in_as(@stranger)
    patch profile_url(@profile), params: { profile: { profile_id: @profile.id, title: 'Julies' } }
    assert_redirected_to root_path
  end

  def test_destroy
    assert_no_difference("Account.count") do
      delete profile_url(@profile)
    end

    sign_in_as(@stranger)
    assert_no_difference("Account.count") do
      delete profile_url(@profile)
    end
  end
end
