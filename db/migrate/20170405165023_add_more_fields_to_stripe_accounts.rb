class AddMoreFieldsToStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :stripe_accounts, :ssn_last_4, :string
    add_column :stripe_accounts, :business_name, :string
    add_column :stripe_accounts, :business_tax_id, :string
    add_column :stripe_accounts, :personal_id_number, :string
    add_column :stripe_accounts, :verification_document, :string
  end
end
