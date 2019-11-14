class CreateApps < ActiveRecord::Migration[6.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :slug
      t.text :structure
      t.text :column_keys
      t.integer :campaign_id
      t.boolean :connected

      t.timestamps
    end
  end
end
