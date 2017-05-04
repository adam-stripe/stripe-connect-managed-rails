class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    # Redirect if no stripe account exists yet
    unless current_user.stripe_account
      redirect_to new_stripe_account_path and return
    end

    begin
      # Retrieve the account object for this user
      @account = Stripe::Account.retrieve(current_user.stripe_account)
      @full_name = "#{@account.legal_entity.first_name}" + " #{@account.legal_entity.last_name}"
    
    # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      handle_error(e.message, 'new')
    
    # Handle any other exceptions
    rescue => e
      handle_error(e.message, 'new')
    end 
  end

  def create
    # Redirect if no token is POSTed or the user doesn't have a Stripe account
    unless params[:stripeToken] && current_user.stripe_account
      redirect_to new_bank_account_path and return
    end

    begin
      # Retrieve the account object for this user
      account = Stripe::Account.retrieve(current_user.stripe_account)

      # Create the bank account
      account.external_account = params[:stripeToken]
      account.save
      
      # Success, send on to the dashboard
      flash[:success] = "Your bank account has been added!"
      redirect_to dashboard_path
    
    # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      handle_error(e.message, 'new')

    # Handle any other exceptions
    rescue => e
      handle_error(e.message, 'new')
    end
  end
end
