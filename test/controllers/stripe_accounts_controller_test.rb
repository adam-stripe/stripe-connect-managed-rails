require 'test_helper'

class StripeAccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect if not logged in" do
    get new_stripe_account_path
    assert_redirected_to new_user_session_path
  end

  test "should require existing stripe account to edit" do
    sign_in @user
    get edit_stripe_account_path("acct_123")
    assert_redirected_to dashboard_path
  end

  test "should load new account creation path" do
    sign_in @user
    get new_stripe_account_path
    assert_response :success
  end

  test "should reject invalid account details and throw an error" do
    sign_in @user
    post stripe_accounts_path, params: {
      stripe_account: {
        dob_day: "100",
        dob_month: "00",
        dob_year: "1992",
        account_type: "individual",
        tos: "true"
      }
    }
    assert_nil @user.stripe_account
    assert_not_empty flash
  end

  test "should successfully create an account" do
    sign_in @user
    post stripe_accounts_path, params: { 
      stripe_account: { 
        first_name: "Test",
        last_name: "Mctesterson",
        dob_day: "29",
        dob_month: "04",
        dob_year: "1992",
        account_type: "individual",
        tos: "true"
      }
    }
    @user.reload
    assert_match(/acct_/, @user.stripe_account)
    assert_redirected_to new_bank_account_path
  end

end
