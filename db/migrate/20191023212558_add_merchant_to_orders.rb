class AddMerchantToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :merchants, :order, foreign_key: true
  end
end
