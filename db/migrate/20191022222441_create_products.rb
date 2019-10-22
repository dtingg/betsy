class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string "name"
      t.string "description"
      t.boolean "active", default: true
      t.integer "stock_qty", default: 10
      t.float "price"

      t.timestamps
    end
  end
end
