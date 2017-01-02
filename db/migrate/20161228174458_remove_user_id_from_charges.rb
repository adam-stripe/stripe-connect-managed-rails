class RemoveUserIdFromCharges < ActiveRecord::Migration[5.0]
  def change
    remove_column :charges, :user_id, :integer
  end
end
