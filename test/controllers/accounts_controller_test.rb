require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    @account = @owner.account
  end

  test "should not get index (currently not supported)" do
    get accounts_url
    assert_response :redirect
  end

  test "redirect new account without user" do
    get new_account_url
    assert_response :redirect
  end

  test 'get show account' do
    sign_in_as(@owner)
    get account_url(@account)
    assert_response :success
  end

  test "get edit account" do
    sign_in_as(@owner)
    get edit_account_url(@account)
    assert_response :success
  end

  test "redirect on edit account not owner" do
    get edit_account_url(@account)
    assert_response :redirect
  end

  test "patch account" do
    sign_in_as(@owner)
    patch account_url(@account), params: { account: { nickname: @account.nickname, user_id: @account.user_id } }
    assert_redirected_to account_url(@account)
  end

  test "should not destroy account (currently not supported)" do
    sign_in_as(@owner)
    assert_no_difference("Account.count") do
      delete account_url(@account)
    end
  end
  # TODO: new account after login / set current_user
  # TODO: create account after login / set current_user
  # TODO: redirect to new account after logged in user has no account
end
