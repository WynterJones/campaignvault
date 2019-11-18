class RemoveTableColumnsFromApps < ActiveRecord::Migration[6.0]
  def change

    remove_column :apps, :table_columns, :jsonb
  end
end
