class AddZapierapiToApps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :zapierapi, :string
  end
end
