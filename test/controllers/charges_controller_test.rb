require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get redirect if not logged in" do
    get '/charges/create'
    assert_response 302
  end

### THIS DOESN'T WORK ####
  # test "should redirect if not authorized to view charge" do
  #   @campaign = Campaign.new(id: 1)
  #   @charge = Charge.new(id: 'ch_2asdgf987asdf98a7as', campaign_id: @campaign)
  #   get '/charges', params: { id: 'ch_2asdgf987asdf98a7as' }
  #   assert_response 302
  # end

end
