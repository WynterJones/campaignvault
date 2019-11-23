class AddTimestampsToDatabases < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :databases
  end
end
