class Order < ApplicationRecord
  has_many :orderitems, dependent: :destroy
  
  validates :status, presence: true
  validates :name, presence: { message: "Name can't be blank"}, :on => :update
  validates :email, presence: { message: "E-mail can't be blank"}, :on => :update
  validates :address, presence: { message: "Address can't be blank"}, :on => :update
  validates :city, presence: { message: "City can't be blank"}, :on => :update
  validates :state, presence: { message: "State can't be blank"}, :on => :update
  validates :zipcode, presence: { message: "Zip code can't be blank"}, :on => :update
  validates :cc_num, length: { in: 13..16, message: "Credit card number must be 13-16 numbers in length" }, :on => :update
  validates :cc_exp, presence: { message: "Credit card expiration can't be blank"}, :on => :update
  validates :cc_cvv, length: { in: 3..4, message: "Credit card cvv must be 3-4 numbers in length" }, :on => :update  
end
