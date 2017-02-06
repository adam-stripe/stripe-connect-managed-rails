ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'stripe_mock'

require "minitest/reporters"
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

class ActiveSupport::TestCase

  def setup
    @password = "password"
    @confirmed_user = User.create(email: "#{rand(50000)}@example.com",
                                  password: @password)

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

  end

  def create_stripe_account
    @stripe_account = Stripe::Account.create(
      managed: true,
      email: @confirmed_user.email,
      legal_entity: {
        first_name: "testy".capitalize,
        last_name: "mctesterson".capitalize,
        type: "individual",
        dob: {
          day: 1,
          month: 1,
          year: 1984
        }
      },
      tos_acceptance: {
        date: Time.now.to_i,
        ip: "5.5.5.5"
      }
    )

    @confirmed_user.stripe_account = @stripe_account.id
  end

  def create_token
    @token = Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 2,
        :exp_year => 2018,
        :cvc => "314"
      },
    )
  end

  def create_charge(token)
    @charge = Stripe::Charge.create({
      source: token,
      amount: 10000,
      currency: "usd",
      application_fee: 10000/10, # Take a 10% application fee for the platform
      destination: "acct_19hhyDAXuVaSZCi2",
      metadata: { "name" => "Bob Boberson", "campaign" => 1 }
    }
  )
  end

  def create_bank_token
    @bank_token = Stripe::Token.create(
      :bank_account => {
      :country => "US",
      :currency => "usd",
      :account_holder_name => "Elizabeth Taylor",
      :account_holder_type => "individual",
      :routing_number => "110000000",
      :account_number => "000123456789",
    },
  )
  end

  def create_bank_account(connected_account, stripeToken)
    @account = Stripe::Account.retrieve(connected_account)
    @bank_account = @account.external_accounts.create(external_account: stripeToken)
  end

end
