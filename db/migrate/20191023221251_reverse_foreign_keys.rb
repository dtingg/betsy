class ReverseForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_reference :merchants, :order, foreign_key: true
    add_reference :orders, :merchant, foreign_key: true
    
    remove_reference :products, :review, foreign_key: true
    add_reference :reviews, :product, foreign_key: true
  end
end
