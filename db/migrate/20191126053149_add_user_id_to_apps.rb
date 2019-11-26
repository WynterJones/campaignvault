class AddUserIdToApps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :user_id, :integer
  end
end
