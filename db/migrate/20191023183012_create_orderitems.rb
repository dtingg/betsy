class CreateOrderitems < ActiveRecord::Migration[5.2]
  def change
    create_table :orderitems do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
