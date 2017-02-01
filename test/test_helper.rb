ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'stripe_mock'

class ActiveSupport::TestCase
#   # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
#   fixtures :all
#
#   # Add more helper methods to be used by all tests here...
  def setup
    @password = "password"
    @confirmed_user = User.create(email: "#{rand(50000)}@example.com",
                                  password: @password
                                  # stripe_account: Stripe::Account.create(
                                  #   :managed => false,
                                  #   :country => "US",
                                  #   :email => "#{rand(50000)}@example.com")
)
    @unconfirmed_user = User.create(email: "#{rand(50000)}@example.com",
                                    password: @password)
  end

  def sign_in(user:, password:)
    post user_session_path \
      "user[email]" => user.email,
      "user[password]" => password
  end

  def create_campaign
    @campaign = Campaign.create(user_id: @confirmed_user.id,
                                title: "Fund my trip to the moon",
                                description: "I'm going to the moon")
    @campaign.save
  end
end
