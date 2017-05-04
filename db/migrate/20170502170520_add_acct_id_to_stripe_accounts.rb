class AddAcctIdToStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :stripe_accounts, :acct_id, :string
  end
end
