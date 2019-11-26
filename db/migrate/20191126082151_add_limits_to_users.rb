class AddLimitsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :campaign_limit, :integer
    add_column :users, :app_limit, :integer
    add_column :users, :database_limit, :integer
    add_column :users, :request_limit, :integer
  end
end
