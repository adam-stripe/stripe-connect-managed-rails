class DisputesController < ApplicationController
  before_action :authenticate_user!

  def create
    if dispute_params[:dispute_text].empty? || dispute_params[:dispute_id].empty?
      flash[:error] = "Please provide supporting information about this dispute"
      redirect_back(fallback_location: root_path) and return
    end

    begin
      # Retrieve the account object for this user
      account = Stripe::Account.retrieve(current_user.stripe_account)

      # Retrieve the dispute
      dispute = Stripe::Dispute.retrieve(dispute_params[:dispute_id])

      # Add the dispute evidence
      dispute.evidence.uncategorized_text = dispute_params[:dispute_text]
      # Add dispute document if one exists
      dispute.evidence.uncategorized_file = dispute_params[:dispute_document]
      dispute.save

      # Success, send back to the page
      flash[:success] = "This dispute has been updated"
      redirect_back(fallback_location: root_path) and return

    # Handle exceptions from Stripe
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to dashboard_path

    # Handle any other exceptions
    rescue => e
      flash[:error] = e.message
      redirect_to dashboard_path
    end
  end

  private
    def dispute_params
      params.permit(:dispute_id, :dispute_text, :dispute_document)
    end
end
