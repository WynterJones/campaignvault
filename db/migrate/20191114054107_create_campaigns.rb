class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
