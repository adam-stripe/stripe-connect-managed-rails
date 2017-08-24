class PayoutsController < ApplicationController
  def show
    # Retrieve the payout from Stripe to get details
    # For large production applications, it's usually best to store this state locally
    if params[:id]
      begin
        @stripe_account = Stripe::Account.retrieve(current_user.stripe_account)

        # Get the payout details
        @payout = Stripe::Payout.retrieve(
          {
            id: params[:id]
          },
          { stripe_account: current_user.stripe_account }
        )

        # Get the balance transactions from the payout
        @txns = Stripe::BalanceTransaction.list(
          {
            payout: params[:id],
            expand: ['data.source.source_transfer', 'data.source.charge.source_transfer'],
            limit: 100
          },
          { stripe_account: current_user.stripe_account }
        )
      # Handle exceptions from Stripe
      rescue Stripe::StripeError => e
        flash[:error] = e.message
        redirect_to dashboard_path
      rescue => e
        # Something else happened, completely unrelated to Stripe
        flash[:error] = e.message
        redirect_to dashboard_path
      end
    else
      flash[:error] = "Sorry, this payout was not found"
      redirect_to dashboard_path
    end
  end
end
