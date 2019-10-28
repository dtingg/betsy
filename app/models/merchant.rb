class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  def member_since
    time_diff_days = ((Time.current - self.created_at) / 1.day).round
    if time_diff_days == 0
      time_diff_hours  = ((Time.current - self.created_at) / 1.hour).round
      membership_duration = time_diff_hours.to_s + " hours"
      return membership_duration
    end
    if time_diff_days >= 365
      time_diff_hours  = ((Time.current - self.created_at) / 1.year).round
      membership_duration = time_diff_hours.to_s + " years"
      return membership_duration
    end
    membership_duration = time_diff_hours.to_s + " days"
    return membership_duration
  end
  
  def active_products
    active_prod = self.products.where(active: true)
    if active_prod.count == 1
      return active_prod.count.to_s + " Active Product"
    end
    return active_prod.count.to_s + " Active Products"
  end
  
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    # merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end
  
  def self.alphabetic
    return Merchant.order(username: :asc)
  end
end
