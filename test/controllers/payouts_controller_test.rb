require 'test_helper'

class PayoutsControllerTest < ActionDispatch::IntegrationTest
  test "should require valid payout ID" do
    get payout_path('fake')
    assert_response :redirect
  end

end
