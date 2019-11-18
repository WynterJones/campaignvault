class RemoveAppIdFromRequests < ActiveRecord::Migration[6.0]
  def change

    remove_column :requests, :app_id, :integer
  end
end
