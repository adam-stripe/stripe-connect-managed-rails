require 'test_helper'

class DebitCardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "should get new" do
    sign_in @user
    create_stripe_account
    @user.stripe_account = @stripe_account.id
    get debit_cards_new_url
    assert_response :success
  end

end
