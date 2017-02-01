require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect to create account if not logged in" do
    get '/campaigns/new'
    assert_redirected_to user_session_path
  end

  test "should not be able to open edit view" do
    get '/campaigns/edit', params: { id: 1 }
    assert_response 302
  end

  test "should not be able to view dashboard" do
    get '/dashboard'
    assert_redirected_to user_session_path
  end

  test "should show a campaign" do
    get '/campaigns', params: { id: 1 }
    assert :success
  end

  test "should create a campaign while logged in" do
    sign_in(user: @confirmed_user, password: @password)
    create_campaign
    get '/campaigns', params: {id: @campaign.id}
    assert :success
  end

end

class ActionController::TestCase
  Devise::Test::ControllerHelpers
end
