class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  def remove_from_cart
    self.product.update_qty(-self.quantity)    
    self.destroy
  end
end
