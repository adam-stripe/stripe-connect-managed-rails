class CreateStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :account_type
      t.integer :dob_month
      t.integer :dob_day
      t.integer :dob_year

      t.timestamps
    end
  end
end
