class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: [:home, :show]
  include CampaignsHelper

  def home
    # Retrieve all active campaigns
    @campaigns = Campaign.where(active: true).order(created_at: :desc).page params[:page]
  end

  def new
    # Redirect if no existing Stripe account
    unless current_user.stripe_account
      redirect_to new_stripe_account_path and return
    end

    # Populate random campaign info
    random_campaign

    # Create a new campaign object
    @campaign = Campaign.new
  end

  def create
    # Create a campaign for the user
    @campaign = current_user.campaigns.new(campaign_params)

    # Redirect to the campaign page once created
    if @campaign.save
      flash[:notice] = "Your campaign has been created!"
      redirect_to @campaign
    else
      handle_error(@campaign.errors.full_messages, 'new')
    end
  end

  def show
    # Retrieve a campaign
    @campaign = Campaign.find(params[:id])

    # List all charges for a given campaign
    @charges = Charge.where(campaign_id: @campaign.id, amount_refunded: nil).order(created_at: :desc)
  end

  def dashboard
    # List campaigns for the current user
    @campaigns = current_user.campaigns.order(created_at: :desc)

    # Redirect if there's not a Stripe account for this user yet
    unless current_user.stripe_account
      flash[:success] = "Create an account to get started."
      redirect_to new_stripe_account_path and return
    end

    # Retrieve charges, transfers, balance transactions, & balance from Stripe
    begin
      @stripe_account = Stripe::Account.retrieve(current_user.stripe_account)

      # Last 100 charges
      @payments = Stripe::Charge.list(
        {
          limit: 100,
          expand: ['data.source_transfer.source_transaction.dispute', 'data.application_fee'],
          source: {object: 'all'}
        },
        { stripe_account: current_user.stripe_account }
      )

      # Last 100 payouts from the managed account to their bank account
      @payouts = Stripe::Payout.list(
        {
          limit: 100,
          expand: ['data.destination']
        },
        { stripe_account: current_user.stripe_account }
      )

      # Retrieve available and pending balance for an account
      @balance = Stripe::Balance.retrieve(stripe_account: current_user.stripe_account)
      @balance_available = @balance.available.first.amount + @balance.pending.first.amount

      # Retrieve transactions with an available_on date in the future
      # For a large platform, it's generally preferrable to handle these async
      transactions = Stripe::BalanceTransaction.all(
        {
          limit: 100,
          available_on: {gte: Time.now.to_i}
        },
        { stripe_account: current_user.stripe_account }
      )

      # Iterate through transactions and sum values for each available_on date
      # For a production app, you'll probably want to store and query these locally instead
      balances = Hash.new
      transactions.auto_paging_each do |txn|
        if balances.key?(txn.available_on)
          balances[txn.available_on] += txn.net
        else
          balances[txn.available_on] = txn.net
        end
      end

      # Sort the results
      @transactions = balances.sort_by {|date,net| date}

      # Check for a debit card external account and determine amount for payout
      @debit_card = @stripe_account.external_accounts.find { |c| c.object == "card"}
      @instant_amt = @balance_available*0.97
      @instant_fee = @balance_available*0.03

    # Handle Stripe exceptions
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to root_path

    # Handle other exceptions
    rescue => e
      flash[:error] = e.message
      redirect_to root_path
    end
  end

  def edit
    # Retrieve the campaign
    @campaign = Campaign.find(params[:id])
  end

  def update
    # Retrieve the campaign
    @campaign = Campaign.find(params[:id])

    # Redirect to view campaign
    if @campaign.update_attributes(campaign_params)
      flash[:notice] = "Your campaign has been updated!"
      redirect_to @campaign
    else
      handle_error(@campaign.errors.full_messages, 'edit')
    end
  end

  def destroy
    # Retrieve the campaign
    campaign = Campaign.find(params[:id])

    # Respond with deletion status
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

    def random_campaign
      data = campaign_data.sample
      @campaign_title = data[:title]
      @campaign_description = data[:description]
      @campaign_image = data[:image]
      @goal = amounts.sample
    end
end
