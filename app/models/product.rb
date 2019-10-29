class Product < ApplicationRecord
  belongs_to :merchant
  has_many :orderitems, dependent: :destroy
  has_many :reviews, dependent: :destroy  
  has_and_belongs_to_many :categories, dependent: :destroy
  
  validates :merchant_id, presence: true
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_qty, numericality: { greater_than_or_equal_to: 0 }, :on => :update
  
  def remove_stock(number)
    unless number < 1
      self.stock_qty -= number
      self.save
    end
  end
  
  def return_stock(number)
    unless number < 1
      self.stock_qty += number
      self.save
    end
  end
  
  def self.highlight
    return Product.find_by(id: 1)
  end

  # orders active products by name
  def self.order_active_products
    active_products_alpha = []
    Product.all.each do |product| 
      if product.active == true 
        active_products_alpha << product
      end
    end
    
    return active_products_alpha.sort_by { |p| p.name }
  end
end
