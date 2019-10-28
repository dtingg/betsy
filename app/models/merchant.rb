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

  def all_orderitems
    merchant_p = self.products

    all_orderitems = []
    gross_sales = 0

    merchant_p.each do |product|
      Orderitem.where(product: product).each do |orderitem|
        all_orderitems << orderitem
      end
    end

    return all_orderitems
  end

  def calculate_gross_sales
    merchant_p = self.products

    all_sales = []
    gross_sales = 0

    merchant_p.each do |product|
      Orderitem.where(product: product).each do |orderitem|
        all_sales << orderitem
      end
    end

    all_sales.each do |orderitem|
      gross_sales += orderitem.total
    end

    return gross_sales
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
