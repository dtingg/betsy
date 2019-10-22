class Order < ApplicationRecord
  belongs_to :merchant
  has_many :orderitems
  
  validates :status, presence: true
  validates :order_date, presence: true 
end
