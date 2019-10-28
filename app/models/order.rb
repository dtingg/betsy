class Order < ApplicationRecord
  has_many :orderitems, dependent: :destroy
  
  validates :status, presence: true
  validates :name, presence: true, :on => :update
  validates :email, presence: true, :on => :update
  validates :address, presence: true, :on => :update
  validates :city, presence: true, :on => :update
  validates :state, presence: true, :on => :update
  validates :zipcode, presence: true, :on => :update
  validates :cc_num, presence: true, :on => :update
  validates :cc_exp, presence: true, :on => :update
  validates :cc_cvv, presence: true, :on => :update  
end
