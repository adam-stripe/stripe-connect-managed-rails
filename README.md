# Fundraising Marketplace: A Stripe Connect example app

An example application built using [Stripe Connect](https://stripe.com/docs/connect) [custom accounts](https://stripe.com/docs/connect/custom-accounts). **This application is provided as an example, but isn't meant to be run in production.**

[![Demo](https://i.imgur.com/2YvhiaL.png)](https://stripe-marketplace-demo.herokuapp.com)


## Demo
**You can find a working demo of this application deployed and running in test mode at https://stripe-marketplace-demo.herokuapp.com/**. Feel free to create an account, create a campaign, and make donations to see some data populated in the dashboard. You can find [test card numbers](https://stripe.com/docs/testing#cards), [bank accounts](https://stripe.com/docs/testing#managed-accounts), and [identity verification](https://stripe.com/docs/connect/testing) details in Stripe's documentation.

## Features
:lock: Uses [Devise](https://github.com/plataformatec/devise) for user authentication.

:money_with_wings: Create fundraising campaigns and custom Stripe Connect accounts.

:chart_with_upwards_trend: Fairly complete seller dashboard to view charges, create refunds, view payouts, etc.

:iphone: Fully responsive for mobile browsers.

:bank: Add and modify connected [bank accounts](https://stripe.com/docs/api#account_create_bank_account).

:credit_card: Make donations with either [Stripe Elements](https://stripe.com/docs/elements) or [Stripe Checkout](https://stripe.com/docs/checkout). [Make successful donations](https://stripe.com/docs/testing#cards) using valid test card numbers or see declines using test cards.

:sunglasses: Take a 10% [application fee](https://stripe.com/docs/connect/charges) from connected accounts for successful charges.

:zap: Create payouts to debit cards using [instant payouts](https://stripe.com/docs/connect/payouts#instant-payouts) and take a 3% platform fee in return using [account debits](https://stripe.com/docs/connect/account-debits).

:clipboard: Identity verification example form and dashboard prompt to work through the [identity verification](https://stripe.com/docs/connect/identity-verification) process. Includes examples of collecting all info up front vs incrementally.

:poop: [Create disputes](https://stripe.com/docs/testing#disputes) and use [webhooks](https://stripe.com/docs/webhooks) to recover funds + dispute fees automatically via account debits.

:arrow_right_hook: Includes [webhook signature validation](https://stripe.com/docs/webhooks#signatures) for enhanced security.

## Shortcomings, things still needed
* Still pretty basic integration tests.
* Email receipts/notifications/etc.
* Additional features like pagination for charges/transfers, ACH payments, alternative payment methods, etc.


## Specs
Built on Rails 5 and running Ruby 2.2. Uses the 2016-07-06 API version.


## Setup
To run this locally, clone the repository and run bundler to install dependencies:

```
git clone https://github.com/adam-stripe/stripe-connect-managed-rails.git
cd stripe-connect-managed-rails
bundle install
```

Migrate:

```
$ rails db:migrate
```

Retrieve your [Stripe API keys](https://dashboard.stripe.com/account/apikeys) and set them as environment variables. You can run this app locally by starting Rails server:

```
PUBLISHABLE_KEY=YOUR_STRIPE_PUBLISHABLE_KEY SECRET_KEY=YOUR_STRIPE_SECRET_KEY ENDPOINT_SECRET=YOUR_WEBHOOK_ENDPOINT_SECRET rails s
```
