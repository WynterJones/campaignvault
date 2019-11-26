class AddUserIdToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :user_id, :integer
  end
end
