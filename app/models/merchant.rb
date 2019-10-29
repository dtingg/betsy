class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true  
  validates :uid, presence: true, uniqueness: true
  
  def member_since
    return "Date unknown" if self.created_at == nil

    time_diff_days = ((Time.current - self.created_at) / 1.day).round

    if time_diff_days == 0
      time_diff_hours  = ((Time.current - self.created_at) / 1.hour).round
      membership_duration = time_diff_hours.to_s + " hours"
    elsif time_diff_days >= 365
      time_diff_years  = ((Time.current - self.created_at) / 1.year).round
      membership_duration = time_diff_years.to_s + " years"
    else
      membership_duration = time_diff_days.to_s + " days"
    end
    
    return membership_duration
  end
  
  def active_products
    active_prod = self.products.where(active: true)

    if active_prod.count == 1
      return active_prod.count
    end

    return active_prod.count
  end

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.username = auth_hash[:info][:nickname]
    merchant.email = auth_hash[:info][:email]

    return merchant
  end
  
  def self.alphabetic
    return Merchant.order(username: :asc)
  end

  def all_orderitems
    all_orderitems = []

    self.products.each do |product|
      Orderitem.where(product: product).each do |orderitem|
        all_orderitems << orderitem
      end
    end

    return all_orderitems
  end

  def calculate_gross_sales
    gross_sales = 0

    self.all_orderitems.each do |orderitem|
      gross_sales += orderitem.total
    end

    return gross_sales
  end

  def calculate_average_rating
    total_rating = 0
    num_of_ratings = 0

    self.products.each do |product|
      if product.reviews
        product.reviews.each do |review|
          total_rating += review.rating
          num_of_ratings += 1
        end
      end
    end 

    return nil if num_of_ratings == 0 
      
    return total_rating/num_of_ratings
  end
end
