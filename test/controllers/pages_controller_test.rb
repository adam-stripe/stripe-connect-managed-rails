require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  test "should load pricing page" do
    get '/pricing'
    assert :success
  end

  test "should load terms page" do
    get '/terms'
    assert :success
  end

end
