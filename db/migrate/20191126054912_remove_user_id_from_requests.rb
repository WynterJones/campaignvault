class RemoveUserIdFromRequests < ActiveRecord::Migration[6.0]
  def change

    remove_column :requests, :user_id, :integer
  end
end
