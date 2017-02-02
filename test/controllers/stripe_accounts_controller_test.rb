require 'test_helper'

class StripeAccountsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect to sign in if no current user" do
    get '/stripe_accounts/new'
    assert_redirected_to user_session_path
  end
