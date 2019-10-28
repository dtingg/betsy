class Product < ApplicationRecord
  belongs_to :merchant
  has_many :orderitems, dependent: :destroy
  has_many :reviews, dependent: :destroy  
  #has_and_belongs_to_many :categories
  
  validates :merchant_id, presence: true
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  def self.active_products_alpha
    active_products_alpha = []
    Product.all.each do |product| 
      if product.active == true 
        active_products_alpha << product
      end
    end

    return active_products_alpha.sort_by { |p| p.name }
  end

  def remove_stock(number)
    self.stock_qty -= number
    self.save
  end
  
  def return_stock(number)
    self.stock_qty += number
    self.save
  end
end
