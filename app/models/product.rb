class Product < ApplicationRecord
  belongs_to :merchant
  has_many :orderitems
  has_many :reviews
  #has_and_belongs_to_many :categories

  validates :merchant_id, presence: true
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
end
