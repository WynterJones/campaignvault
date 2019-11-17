class CreateDatabase < ActiveRecord::Migration[6.0]
  def change
    create_table :databases do |t|
      t.string :name
      t.string :slug
      t.boolean :connected, null: false, default: false
      t.jsonb :table_columns, null: false, default: '{}'
      t.integer :campaign_id
      t.integer :app_id
    end
  end
end
