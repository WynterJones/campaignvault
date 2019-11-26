class AddUserIdToDatabases < ActiveRecord::Migration[6.0]
  def change
    add_column :databases, :user_id, :integer
  end
end
