class RemoveStuffFromRequests < ActiveRecord::Migration[6.0]
  def change

    remove_column :requests, :campaign_id, :integer

    remove_column :requests, :app_id, :integer

    remove_column :requests, :body, :text
  end
end
