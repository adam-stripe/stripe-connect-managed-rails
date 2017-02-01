require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should load pricing page" do
    get '/pricing'
    assert :success
  end
end
