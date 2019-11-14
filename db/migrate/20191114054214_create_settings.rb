class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :timezone
      t.string :date_format
      t.integer :user_id

      t.timestamps
    end
  end
end
