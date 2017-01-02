class AddGoalToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :goal, :integer
  end
end
