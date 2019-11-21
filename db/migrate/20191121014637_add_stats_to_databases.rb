class AddStatsToDatabases < ActiveRecord::Migration[6.0]
  def change
    add_column :databases, :stats, :jsonb, null: false, default: '{}'
  end
end
