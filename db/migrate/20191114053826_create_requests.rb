class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.text :body
      t.integer :campaign_id
      t.integer :app_id

      t.timestamps
    end
  end
end
