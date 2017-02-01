class BankAccountsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    # Redirect if no stripe account yet
    unless current_user.stripe_account
      redirect_to new_stripe_account_path
    end

    begin
      # Retrieve the account object for this user
      @account = Stripe::Account.retrieve(current_user.stripe_account)
      @full_name = "#{@account.legal_entity.first_name}" + " #{@account.legal_entity.last_name}"

    rescue Stripe::RateLimitError => e
      flash[:alert] = e.message
      render 'new'
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = e.message
      render 'new'
    rescue Stripe::AuthenticationError => e
      flash[:alert] = e.message
      render 'new'
    rescue Stripe::APIConnectionError => e
      flash[:alert] = e.message
      render 'new'
    rescue Stripe::StripeError => e
      flash[:alert] = e.message
      render 'new'
    rescue => e
      puts e
      # Something else failed in the app. Maybe log or send an email?
      flash[:alert] = "Sorry, we weren't able to retrieve this account."
      render 'new'
    end
  end

  def create
    if params[:stripeToken]
      if current_user.stripe_account
        begin
          # Retrieve the account object for this user
          account = Stripe::Account.retrieve(current_user.stripe_account)

          # Create the bank account
          account.external_accounts.create(external_account: params[:stripeToken])

          flash[:success] = "Your bank account has been added!"
          redirect_to dashboard_path

        # Handle exceptions
        rescue Stripe::RateLimitError => e
          flash[:alert] = e.message
          render 'new'
        rescue Stripe::InvalidRequestError => e
          flash[:alert] = e.message
          render 'new'
        rescue Stripe::AuthenticationError => e
          flash[:alert] = e.message
          render 'new'
        rescue Stripe::APIConnectionError => e
          flash[:alert] = e.message
          render 'new'
        rescue Stripe::StripeError => e
          flash[:alert] = e.message
          render 'new'
        rescue => e
          # Something else failed in the app. Maybe log or send an email?
          flash[:alert] = "Sorry, we weren't able to add this bank account."
          render 'new'
        end
      end
    end
  end

end
