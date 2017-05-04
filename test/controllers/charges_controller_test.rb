require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should not show charges unless logged in" do
    get charge_path(@campaign)
    assert_redirected_to new_user_session_path
  end

  test "should require token to create a charge" do
    post charges_path, params: { amount: 100, name: "User", campaign: @campaign }
    assert_response :redirect
  end

  test "should create successful charge" do
    create_stripe_account
    @campaign.user_id = @user.id
    @user.stripe_account = @stripe_account.id
    @user.save
    charge_amount = rand(10..50)
    post charges_path, params: { amount: charge_amount, name: "User", campaign: @campaign.id, stripeToken: 'tok_visa' }
    assert_equal(charge_amount*100, Charge.last.amount)
  end


end
