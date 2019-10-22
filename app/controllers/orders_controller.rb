class OrdersController < ApplicationController
  
  private
  
  def order_params
    return params.require(:order).permit(:status, :name, :address, :city, :state, :zipcode, :order_date, :merchant_id)
  end  
end
