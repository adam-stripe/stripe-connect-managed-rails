# Fundraising Marketplace: A Stripe Connect example app

An example application built using [Stripe Connect](https://stripe.com/docs/connect) [managed accounts](https://stripe.com/docs/connect/managed-accounts). 

**Note: this application is provided as an example, but isn't meant to be run in production**

## Demo
You can find a working demo of this application deployed and running in test mode at https://stripe-marketplace-demo.herokuapp.com/. Feel free to create an account, create a campaign, and make donations to see some data populated in the dashboard. You can find [test card numbers](https://stripe.com/docs/testing#cards), [bank accounts](https://stripe.com/docs/testing#managed-accounts), and [identity verification](https://stripe.com/docs/connect/testing) details in Stripe's documentation.

## Features
* Create fundraising campaigns and managed Stripe Connect accounts. 
* Add and modify connected [bank accounts](https://stripe.com/docs/api#account_create_bank_account). 
* [Make successful donations](https://stripe.com/docs/testing#cards) and see declines using test cards.
* Fairly complete seller dashboard (doesn't include disputes, pagination, and some other features yet) to view charges, create refunds, see transfers, etc. 
* Identity verification example form and dashboard prompt to work through the [identity verification](https://stripe.com/docs/connect/identity-verification) process. 
* Uses [Devise](https://github.com/plataformatec/devise) for use authentication, [Unsplash](https://unsplash.it/) for example images, etc. 

## Shortcomings, things still needed
* Still needs some cleanup and refactoring.
* Tests!
* Email receipts/notifications/etc.
* Additional features like pagination for charges/transfers, disputes in the dashboard, ACH payments, alternative payment methods, payouts to debit cards, etc. 
* Some other additional validations.


## Specs
Built on Rails 5 and running Ruby 2.2. Uses the 2016-07-06 API version.


## Setup
To run this locally, clone the repository and run bundler to install dependencies:

```
git clone https://github.com/adam-stripe/stripe-connect-managed-rails.git
bundle install
```

Migrate:

```
$ rails db:migrate
```

Retrieve your [Stripe API keys](https://dashboard.stripe.com/account/apikeys) and set them as environment variables. You'll also need to retrieve and load credentials from [Unsplash](https://unsplash.com/oauth/applications) if you'll use their API for built in images as this example does. Your can run this locally by starting Rails server:

```
PUBLISHABLE_KEY=YOUR_STRIPE_PUBLISHABLE_KEY SECRET_KEY=YOUR_STRIPE_SECRET_KEY APPLICATION_ID=UNSPLASH_APP_ID APPLICATION_SECRET=UNSPLASH_APP_SECRET rails s
```