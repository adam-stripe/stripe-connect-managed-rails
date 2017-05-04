ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Stripe.api_key = ENV['SECRET_KEY']

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    @user = users(:one)
    @campaign = campaigns(:one)
  end

  # Create a US bank token
  def create_bank_token
    @btok = Stripe::Token.create(
      bank_account: { 
        country: "US",
        currency: "usd",
        routing_number: "110000000",
        account_number: "000123456789"
      }
    )
  end

  # Create a Stripe account to use for tests
  def create_stripe_account
    @stripe_account = Stripe::Account.create(managed: true, country: "us")
  end
end