class RemoveCampaignIdFromDatabases < ActiveRecord::Migration[6.0]
  def change

    remove_column :databases, :campaign_id, :integer
  end
end
