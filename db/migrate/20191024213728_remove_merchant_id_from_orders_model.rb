class RemoveMerchantIdFromOrdersModel < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :merchant, foreign_key: true
  end
end
