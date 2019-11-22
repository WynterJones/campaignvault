class AddValuesToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :values, :text
  end
end
