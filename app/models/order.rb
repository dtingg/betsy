class Order < ApplicationRecord
  has_many :orderitems
  
  validates :status, presence: true
end
