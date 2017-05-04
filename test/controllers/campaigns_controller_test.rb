require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should load root path" do
    get root_path
    assert_response :success
    assert_select 'title', "Stripe Connect Example App"
  end

  test "should load campaign" do
    get campaign_path(@campaign)
    assert_response :success
  end

  test "should require login to create a campaign" do
    get new_campaign_path
    assert_redirected_to new_user_session_path
  end

  test "should redirect if no stripe account" do
    sign_in @user
    get new_campaign_path
    assert_redirected_to new_stripe_account_path
  end

  test 'should create a campaign successfully' do
    sign_in @user
    create_stripe_account
    @user.stripe_account = @stripe_account.id
    post campaigns_path, params: { campaign: { title: "Title", description: "Help me do a thing", goal: 100, image: "https://unsplash.it" } }
    assert_redirected_to campaign_path(Campaign.last)
  end
end
