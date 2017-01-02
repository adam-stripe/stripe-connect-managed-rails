class AddStripeAccountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_account, :string
  end
end
