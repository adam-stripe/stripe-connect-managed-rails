require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest

  def stripe_helper
    StripeMock.create_test_helper
  end

  def setup
    StripeMock.start
  end

  def teardown
    StripeMock.stop
  end

  test "should be a stripe webhook" do
    event = StripeMock.mock_webhook_event('account.updated')
    account_object = event.data.object
    assert_not_nil "account_object.id"
    assert_not_nil "account_object.email"
  end
end
