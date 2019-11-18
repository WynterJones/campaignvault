class AddStuffToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :campaign_id, :integer
    add_column :requests, :app_id, :integer
  end
end
