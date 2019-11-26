class AddStuffToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :company, :string
    add_column :settings, :footer, :string
  end
end
