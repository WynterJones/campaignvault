class RemoveConnectedFromApps < ActiveRecord::Migration[6.0]
  def change

    remove_column :apps, :connected, :boolean
  end
end
