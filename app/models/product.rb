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
    return Product.all.sample(5)
  end
  
  def calculate_average_rating
    total_rating = 0.0
    num_of_ratings = 0
    
    if (self.reviews).count == 0
      return "Not Yet Rated"
    end
    
    self.reviews.each do |review|
      total_rating += review.rating
      num_of_ratings += 1
    end
    
    average = (total_rating/num_of_ratings).to_i
    
    star = "\u2605"
    rating = star.encode("utf-8") * average
    return rating
    
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
