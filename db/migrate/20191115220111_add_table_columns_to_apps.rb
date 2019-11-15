class AddTableColumnsToApps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :table_columns, :jsonb, null: false, default: '{}'
  end
end
