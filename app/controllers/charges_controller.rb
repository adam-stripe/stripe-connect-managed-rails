class ChargesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :destroy]

  def create
    # Check for a stripeToken
    unless charge_params[:stripeToken]
      flash[:error] = "No payment information submitted."
      redirect_back
    end
    
    # Check for a valid campaign ID
    unless charge_params[:campaign] && Campaign.exists?(charge_params[:campaign])
      flash[:error] = "The campaign you specified doesn't exist."
      redirect_back
    end

    # Retrieve the campaign
    campaign = Campaign.find(params[:campaign])

    begin
      # Find the account ID associated with this campaign
      account_id = User.find(campaign.user_id).stripe_account

      # Convert the amount to cents
      amount = (100 * charge_params[:amount].tr('$', '').to_r).to_i
      
      # Create the charge with Stripe
      charge = Stripe::Charge.create({
        source: charge_params[:stripeToken],
        amount: amount,
        currency: "usd", 
        application_fee: amount/10, # Take a 10% application fee for the platform
        destination: account_id, 
        metadata: { "name" => charge_params[:name], "campaign" => campaign.id }
        }
      )

      # Save the charge details for later use
      local_charge = Charge.create(
        charge_id: charge.id,
        amount: amount,
        name: charge_params[:name],
        campaign_id: campaign.id
      )

      # Update the amount raised for this campaign
      campaign.raised = campaign.raised.to_i + amount
      campaign.save

      # Let the customer know the payment was successful
      flash[:success] = "Thanks for your donation! Your transaction ID is #{charge.id}."
      redirect_to campaign_path(campaign)
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    rescue => e
      # Something else happened, completely unrelated to Stripe
      flash[:error] = e.message
      redirect_to campaign_path(campaign)
    end
  end

  def show
    begin
      # Retrieve the charge from Stripe
      @charge = Stripe::Charge.retrieve(id: params[:id], expand: ['application_fee'])

      # Validate that the user should be able to view this charge
      check_destination(@charge)

      @campaign = Campaign.find(@charge.metadata.campaign)
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      flash[:error] = e.message
      render :show
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      flash[:error] = e.message
      render :show
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      flash[:error] = e.message
      render :show
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      flash[:error] = e.message
      render :show
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      flash[:error] = e.message
      render :show
    rescue => e
      # Something else happened, completely unrelated to Stripe
      flash[:error] = e.message
      render :show
    end
  end

  def index
  end

  def destroy
    begin
      # Retrieve the charge from Stripe
      charge = Stripe::Charge.retrieve(params[:id])

      # Validate that the user should be able to view this charge
      check_destination(charge)

      # Refund the charge
      charge.refund(reverse_transfer: true, refund_application_fee: true)

      # Update the local charge
      local_charge = Charge.find_by charge_id: charge.id
      local_charge.amount_refunded = charge.amount
      local_charge.save

      # Update the amount raised for this campaign
      campaign = Campaign.find(local_charge.campaign_id)
      campaign.raised = campaign.raised.to_i - charge.amount
      campaign.save

      # Let the user know the refund was successful
      flash[:success] = "The charge has been refunded."
      redirect_to dashboard_path
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
      flash[:error] = e.message
      redirect_to dashboard_path
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      flash[:error] = e.message
      redirect_to dashboard_path
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      flash[:error] = e.message
      redirect_to dashboard_path
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      flash[:error] = e.message
      redirect_to dashboard_path
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      flash[:error] = e.message
      redirect_to dashboard_path
    rescue => e
      # Something else happened, completely unrelated to Stripe
      flash[:error] = e.message
      redirect_to dashboard_path
    end
  end

  private
    def charge_params
      params.permit(:amount, :stripeToken, :name, :campaign, :authenticity_token)
    end

    def check_destination(charge)
      unless charge.destination.eql?(current_user.stripe_account)
        flash[:error] = "You don't have access to this charge."
        redirect_to dashboard_path
      end
    end
end
