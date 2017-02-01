class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :dashboard]

  def home
    @campaigns = Campaign.where(active: true).order(created_at: :desc)
  end

  def new
    # Check for an existing Stripe account
    unless current_user.stripe_account
      redirect_to new_stripe_account_path
    end

    # Retrieve images
    random_image

    @campaign = Campaign.new
  end

  def create
    @campaign = current_user.campaigns.create(campaign_params)
    if @campaign.save
      flash[:notice] = "Your campaign has been created!"
      redirect_to @campaign
    else
      flash.now[:danger] = @campaign.errors.full_messages
      random_image
      render :new
    end
  end

  def show
    @campaign = Campaign.find(params[:id])

    @charges = Charge.where(campaign_id: @campaign.id, amount_refunded: nil).order(created_at: :desc)
  end

  def dashboard
    @campaigns = current_user.campaigns.order(created_at: :desc)

    # Retrieve charges, transfers, balance transactions, & balance from Stripe
    if current_user.stripe_account
      @stripe_account = Stripe::Account.retrieve(current_user.stripe_account)

      @payments = Stripe::Charge.list(
        {
          limit: 100,
          expand: ['data.source_transfer', 'data.application_fee']
        },
        { stripe_account: current_user.stripe_account }
      )

      @transfers = Stripe::Transfer.list(
        {
          limit: 100
        },
        { stripe_account: current_user.stripe_account }
      )

      @balance = Stripe::Balance.retrieve(stripe_account: current_user.stripe_account)

      # Retrieve transactions with an available_on date in the future
      transactions = Stripe::BalanceTransaction.all(
        {
          limit: 100,
          available_on: {gte: Time.now.to_i}
        },{ stripe_account: current_user.stripe_account })

      balances = Hash.new

      # Iterate through transactions and sum values for each available_on date
      transactions.auto_paging_each do |txn|
        if balances.key?(txn.available_on)
          balances[txn.available_on] += txn.net
        else
          balances[txn.available_on] = txn.net
        end
      end

      # Sort the results
      @transactions = balances.sort_by {|date,net| date}
    else
      flash[:success] = "Create a fundraising campaign to get started."
      redirect_to new_campaign_path
    end

  end

  def edit
    @campaign = Campaign.find(params[:id])
    random_image

    if current_user
      # owns campaign
      if current_user.id == @campaign.user_id
        render :edit
      else
      # doesn't own campaign
      redirect_to @campaign
      end
    else
      redirect_to @campaign
    end
    
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update_attributes(campaign_params)
      flash[:notice] = "Your campaign has been updated!"
      redirect_to @campaign
    else
      flash.now[:danger] = @campaign.errors.full_messages
      random_image
      render :edit
    end
  end

  def destroy
    campaign = Campaign.find(params[:id])

    if campaign.update_attributes(active: false)
      flash[:notice] = "Your campaign has been deleted."
      redirect_to dashboard_path
    else
      flash[:error] = "We weren't able to delete this campaign."
      redirect_to dashboard_path
    end
  end

  private
    def campaign_params
      params.require(:campaign).permit(:title, :description, :goal, :subscription, :image)
    end

    # Generate a random user image for the authenticated user
    def random_image
      @images = Unsplash::Photo.all(page = rand(1...99), per_page = 9)
    end
end
