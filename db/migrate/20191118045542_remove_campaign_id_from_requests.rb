class RemoveCampaignIdFromRequests < ActiveRecord::Migration[6.0]
  def change

    remove_column :requests, :campaign_id, :integer
  end
end
