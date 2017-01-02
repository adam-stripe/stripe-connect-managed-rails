class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.string :charge_id
      t.integer :amount
      t.integer :amount_refunded
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end
end
