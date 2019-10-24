class OrdersController < ApplicationController
  
  private
  
  def order_params
    return params.require(:order).permit(:status, :name, :email, :address, :city, :state, :zipcode, :cc_num, :cc_exp, :cc_cvv, :order_date, :merchant_id)
  end  
end
