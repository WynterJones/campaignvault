class AddLogoToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :logo, :string
  end
end
