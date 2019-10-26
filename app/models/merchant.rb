class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
  
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    # merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end
  
  def self.alphabetic
    return Merchant.order(name: :asc)
  end
  
  def self.gross_sales
  end
  
  def self.top_rated
  end
end
