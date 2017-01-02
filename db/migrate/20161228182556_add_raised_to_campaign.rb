class AddRaisedToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :raised, :integer
  end
end
