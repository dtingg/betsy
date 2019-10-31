class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  def increase_qty(additional_qty)
    self.quantity += additional_qty.to_i
    self.product.remove_stock(additional_qty.to_i)
    self.save
  end
  
  def check_qty(desired_purchase)
    if self.product.stock_qty - desired_purchase.to_i >= 0 && self.product.active == true
      return true
    end

    return false
  end

  def remove_from_cart
    self.product.return_stock(self.quantity)    
    self.destroy
  end
  
  def total
    total = self.quantity * self.product.price
    return total
  end
  
  def mark_complete
    self.complete = true
    self.save
  end

  
  
  def self.exists?(order_id, product_id)
    result = Orderitem.where(order_id: order_id, product_id: product_id)  
    
    if result.empty?
      return false
    else
      return result[0]
    end
  end
end
