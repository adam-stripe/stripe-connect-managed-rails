class AddNameToCharges < ActiveRecord::Migration[5.0]
  def change
    add_column :charges, :name, :string
  end
end
