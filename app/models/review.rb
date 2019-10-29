class Review < ApplicationRecord
  belongs_to :product
  
  validates :reviewer, presence: true
  validates :comment, presence: true
  validates :product_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
end
