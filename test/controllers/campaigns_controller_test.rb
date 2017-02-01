require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect to create account if not logged in" do
    get '/campaigns/new'
    # assert_response 302
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

#
# make sure you get an error when you submit a form without details
#
# make sure you can’t see a charge if you’re not supposed to see it
#
# make sure you can’t see a campaign that isn’t yours
#
# make sure you’re auth’d to access certain pages


# create_table "users", force: :cascade do |t|
#   t.string   "email",                  default: "", null: false
#   t.string   "encrypted_password",     default: "", null: false
#   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",          default: 0,  null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string   "current_sign_in_ip"
#   t.string   "last_sign_in_ip"
#   t.datetime "created_at",                          null: false
#   t.datetime "updated_at",                          null: false
#   t.string   "stripe_account"
