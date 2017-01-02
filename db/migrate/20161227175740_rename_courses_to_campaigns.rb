class RenameCoursesToCampaigns < ActiveRecord::Migration[5.0]
  def change
    rename_table :courses, :campaigns
  end
end
