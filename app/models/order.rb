class Order < ApplicationRecord
  has_many :orderitems, dependent: :destroy
  
  validates :status, presence: true    
  validates :name, presence: { message: "Name can't be blank"}, :on => :update
  validates :email, format: { with: /\A.+@.+\..{2,3}\z/, message: "E-mail address must be valid"}, :on => :update
  validates :address, presence: {message: "Address can't be blank"}, :on => :update
  validates :city, presence: { message: "City can't be blank"}, :on => :update
  validates :state, format: { with: /\A[a-zA-Z]{2}\z/, message: "State must be two letters in length"}, :on => :update
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "Zip code must be 5 digits" }, :on => :update
  validates :cc_num, format: { with: /\A\d{13,16}\z/, message: "Credit card number must be 13-16 numbers in length" }, :on => :update
  validates :cc_exp, format: { with: /\A(0?[1-9]|1[012])\/?(19|2[\d])\z/, message: "Credit card expiration must be valid" }, :on => :update
  validates :cc_cvv, format: { with: /\A\d{3,4}\z/, message: "Credit card CVV must be 3-4 numbers in length" }, :on => :update  
  
  def total
    order_total = self.orderitems.sum do |orderitem|
      orderitem.total
    end
    
    return order_total 
  end
end

#   def check_complete
#     self.orderitems.each do |orderitem|
#       if orderitem.complete != true
#         return false
#       end
#     end
#     return true
#   end
# end
