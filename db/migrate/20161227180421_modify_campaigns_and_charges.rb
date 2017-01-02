class ModifyCampaignsAndCharges < ActiveRecord::Migration[5.0]
  def change
    remove_column :campaigns, :content_link, :string
    remove_column :campaigns, :price, :integer
    rename_column :charges, :course_id, :campaign_id
  end
end
