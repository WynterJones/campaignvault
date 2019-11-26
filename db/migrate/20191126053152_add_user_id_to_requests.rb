class AddUserIdToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :user_id, :integer
  end
end
