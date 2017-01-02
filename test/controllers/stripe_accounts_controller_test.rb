require 'test_helper'

class StripeAccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_accounts_create_url
    assert_response :success
  end

  test "should get update" do
    get stripe_accounts_update_url
    assert_response :success
  end

end
