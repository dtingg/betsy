class Order < ApplicationRecord
  has_many :orderitems, dependent: :destroy
  
  validates :status, presence: true
  
  def order_item_total
  end
  
  def order_item_total
  end
  
  def order_item_qty
  end
end
