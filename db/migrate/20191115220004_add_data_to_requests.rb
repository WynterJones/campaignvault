class AddDataToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :data, :jsonb, null: false, default: '{}'
  end
end
