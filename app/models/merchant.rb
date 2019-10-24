class Merchant < ApplicationRecord
  has_many :orders
  has_many :products

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    # user.provider = "github"
    merchant.username = auth_hash["info"]["username"]
    merchant.email = auth_hash["info"]["email"]

  #   # Note that the user has not been saved.
  #   # We'll choose to do the saving outside of this method
  #   return merchant
    end

  # def self.alphabetic
  #   return Merchant.order(name: :asc)
  # end
end
