class AddFieldsToStripeAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :stripe_accounts, :address_city, :string
    add_column :stripe_accounts, :address_state, :string
    add_column :stripe_accounts, :address_line1, :string
    add_column :stripe_accounts, :address_postal, :string
    add_column :stripe_accounts, :tos, :boolean
  end
end
