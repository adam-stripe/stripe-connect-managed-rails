require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest

  test "should get redirect if not logged in" do
    get '/charges/create'
    assert_response 302
  end

end

class ActionController::TestCase
  Devise::Test::ControllerHelpers
end
