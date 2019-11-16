class RemoveStructureAndColumnKeysFromApps < ActiveRecord::Migration[6.0]
  def change

    remove_column :apps, :structure
    remove_column :apps, :column_keys
  end
end
