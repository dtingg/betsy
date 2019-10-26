class Product < ApplicationRecord
  belongs_to :merchant
  has_many :orderitems, dependent: :destroy
  has_many :reviews, dependent: :destroy  
  #has_and_belongs_to_many :categories
  
  validates :merchant_id, presence: true
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  def decrease_qty(number)
    self.stock_qty -= number
    self.save
  end
  
  def increase_qty(number)
    self.stock_qty += number
    self.save
  end
end
