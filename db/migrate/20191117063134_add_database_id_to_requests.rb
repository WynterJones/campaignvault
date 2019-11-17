class AddDatabaseIdToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :database_id, :integer
  end
end
