class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.date :order_date

      t.timestamps
    end
  end
end
