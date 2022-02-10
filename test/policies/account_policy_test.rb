require 'test_helper'

class AccountPolicyTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_user_with_account
    @account = @owner.account
    @guest = create_user_with_account
    @stranger = create_user_with_account
  end

  def test_scope
  end

  def test_show
    #private
    sign_in_as(@owner)
    get account_url(@account)
    assert_response :success

    sign_in_as(@guest)
    get account_url(@account)
    assert_redirected_to root_path

    sign_in_as(@stranger)
    get account_url(@account)
    assert_redirected_to root_path

  end

  def test_create
    # no user
    post accounts_url, params: { account: { user: @guest, nickname: SecureRandom.alphanumeric(10) } }
    assert_response :redirect

    # user
    @guest.account.destroy!
    sign_in_as(@guest)
    assert_difference("Account.count") do
      post accounts_url, params: { account: { nickname: SecureRandom.alphanumeric(10) } }
    end
    assert_redirected_to account_url(Account.last)
  end

  def test_update
    sign_in_as(@owner)
    patch account_url(@account), params: { account: { account_id: @account.id, nickname: @account.nickname } }
    assert_redirected_to account_url(@account)

    sign_in_as(@guest)
    patch account_url(@account), params: { account: { account_id: @account.id, nickname: @account.nickname } }
    assert_redirected_to root_path

    sign_in_as(@stranger)
    patch account_url(@account), params: { account: { account_id: @account.id, nickname: @account.nickname } }
    assert_redirected_to root_path
  end

  def test_destroy
    sign_in_as(@owner)
    assert_no_difference("Account.count") do
      delete account_url(@account)
    end

    sign_in_as(@guest)
    assert_no_difference("Account.count") do
      delete account_url(@account)
    end

    sign_in_as(@stranger)
    assert_no_difference("Account.count") do
      delete account_url(@account)
    end
  end
end
