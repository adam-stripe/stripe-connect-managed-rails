require 'test_helper'

class BankAccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect if not authenticated" do
    get new_bank_account_path
    assert_redirected_to new_user_session_path
  end

  test 'should not allow post if not authenticated' do
    post bank_accounts_path "stripeToken": "tok_123"
    assert_redirected_to new_user_session_path
  end

  test 'should redirect if no stripe account' do
    sign_in @user
    get new_bank_account_path
    assert_redirected_to new_stripe_account_path
  end

  test 'should load bank accounts page if stripe account exists' do
    sign_in @user
    @user.stripe_account = "acct_abc123"
    get new_bank_account_path
    assert_response :success
  end

  test 'should attach a valid bank account' do
    sign_in @user
    create_stripe_account
    @user.stripe_account = @stripe_account.id
    create_bank_token
    post bank_accounts_path, params: { stripeToken: @btok.id }
    assert_redirected_to dashboard_path
  end
end
