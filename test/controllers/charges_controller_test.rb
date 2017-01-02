require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get charges_create_url
    assert_response :success
  end

  test "should get show" do
    get charges_show_url
    assert_response :success
  end

  test "should get index" do
    get charges_index_url
    assert_response :success
  end

end
