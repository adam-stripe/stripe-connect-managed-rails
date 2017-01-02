class StripeAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    @stripe_account = StripeAccount.new
  end

  def create
    @stripe_account = StripeAccount.new(account_params)

    if @stripe_account.valid?
      begin
        # Create the account object in Stripe
        account = Stripe::Account.create(
          managed: true,
          legal_entity: {
            first_name: account_params[:first_name].capitalize,
            last_name: account_params[:last_name].capitalize,
            type: account_params[:account_type], 
            dob: {
              day: account_params[:dob_day], 
              month: account_params[:dob_month], 
              year: account_params[:dob_year]
            }
          },
          tos_acceptance: {
            date: Time.now.to_i, 
            ip: request.remote_ip
          }
        )

      # Save the account ID for this user for later
      current_user.stripe_account = account.id

      if current_user.save
        flash[:success] = "Your seller account has been created! 
          Next, add a bank account where you'd like to receive transfers below."
        redirect_to new_bank_account_path
      else
        # Something else failed in the app. Maybe log or send an email?
        flash[:alert] = "Sorry, we weren't able to save this account."
      end
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
        flash[:alert] = "Sorry, we weren't able to create this account."
        render 'new'
      end
    else
      flash.now[:danger] = @stripe_account.errors.full_messages
      render :new
    end
  end

  def edit
    # Check for a valid account ID
    unless params[:id] && params[:id].eql?(current_user.stripe_account)
      flash[:error] = "No seller account specified"
      redirect_to dashboard_path
    end

    @stripe_account = Stripe::Account.retrieve(params[:id])

    if @stripe_account.verification.fields_needed.empty?
      flash[:success] = "Your information is all up to date."
      redirect_to dashboard_path
    end
  end

  def update
    # Check for an existing Stripe account
    unless current_user.stripe_account
      redirect_to new_stripe_account_path
    end

    # Retrieve the account from Stripe
    @stripe_account = Stripe::Account.retrieve(current_user.stripe_account)

    @stripe_account.verification.fields_needed.each do |field|
      # Reject empty values
      if account_params[field.to_sym].empty?
        flash[:alert] = "Please complete all fields."
        render 'edit' and return
      end

      # Update each needed attribute
      case field
      when 'legal_entity.address.city'
        @stripe_account.legal_entity.address.city = account_params[field.to_sym]
      when 'legal_entity.address.line1'
        @stripe_account.legal_entity.address.line1 = account_params[field.to_sym]
      when 'legal_entity.address.postal_code'
        @stripe_account.legal_entity.address.postal_code = account_params[field.to_sym]
      when 'legal_entity.address.state'
        @stripe_account.legal_entity.address.state = account_params[field.to_sym]
      when 'legal_entity.dob.day'
        @stripe_account.legal_entity.dob.day = account_params[field.to_sym]
      when 'legal_entity.dob.month'
        @stripe_account.legal_entity.dob.month = account_params[field.to_sym]
      when 'legal_entity.dob.year'
        @stripe_account.legal_entity.dob.year = account_params[field.to_sym]
      when 'legal_entity.first_name'
        @stripe_account.legal_entity.first_name = account_params[field.to_sym]
      when 'legal_entity.last_name'
        @stripe_account.legal_entity.last_name = account_params[field.to_sym]
      when 'legal_entity.ssn_last_4'
        @stripe_account.legal_entity.ssn_last_4 = account_params[field.to_sym]
      when 'legal_entity.type'
        @stripe_account.legal_entity.type = account_params[field.to_sym]
      when 'legal_entity.personal_id_number'
        @stripe_account.legal_entity.personal_id_number = account_params[field.to_sym]
      when 'legal_entity.verification.document'
        @stripe_account.legal_entity.verification.document = account_params[field.to_sym]
      end
    end

    begin
      @stripe_account.save
      flash[:success] = "Thanks! Your account has been updated."
      redirect_to dashboard_path and return
    rescue Stripe::RateLimitError => e
      flash[:alert] = e.message
      render 'edit'
    rescue Stripe::InvalidRequestError => e
      flash[:alert] = e.message
      render 'edit'
    rescue Stripe::AuthenticationError => e
      flash[:alert] = e.message
      render 'edit'
    rescue Stripe::APIConnectionError => e
      flash[:alert] = e.message
      render 'edit'
    rescue Stripe::StripeError => e
      flash[:alert] = e.message
      render 'edit'
    rescue => e
      # Something else failed in the app. Maybe log or send an email?
      flash[:alert] = "Sorry, we weren't able to update your account."
      render 'edit'
    end
  end

  private
    def account_params
      params.require(:stripe_account).permit(
        :first_name, :last_name, :account_type, :dob_month, :dob_day, :dob_year, :tos, :legal_entity, 
        :'legal_entity.first_name', :'legal_entity.last_name', :'legal_entity.address.city', 
        :'legal_entity.address.line1', :'legal_entity.address.postal_code',
        :'legal_entity.address.state', :'legal_entity.dob.day',
        :'legal_entity.dob.month', :'legal_entity.dob.year', :'legal_entity.ssn_last_4', 
        :'legal_entity.personal_id_number', :'legal_entity.type', :'legal_entity.verification.document',
      )
    end
end
