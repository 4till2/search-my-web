require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    @profile = @owner.account.profile
    sign_in_as(@owner)
  end

  test 'should not get index (currently not supported)' do
    get profiles_url
    assert_response :redirect
  end

  test 'get new' do
    get new_profile_url
    assert_response :success

    sign_out_user
    get new_profile_url
    assert_response :redirect
  end

  test 'should create profile' do
    @owner.account.profile.destroy
    assert_difference('Profile.count') do
      post profiles_url,
           params: { profile: { account_id: @profile.account_id, bio: @profile.bio, title: @profile.title } }
    end
    assert_redirected_to profile_url(Profile.last)
  end

  test 'get show profile' do
    get profile_url(@profile)
    assert_response :success
  end

  test "get edit profile" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test 'should update profile' do
    patch profile_url(@profile),
          params: { profile: { account_id: @profile.account_id, bio: @profile.bio, title: @profile.title } }
    assert_redirected_to profile_url(@profile)
  end

  test 'should not destroy profile' do
    assert_no_difference('Profile.count') do
      delete profile_url(@profile)
    end

    assert_response :redirect
  end
end
