class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:destroy]
  
  def create
    Orderitem.create(quantity: 1, order_id: session[:order_id], product_id: 6)
  end
  
  def destroy
    @orderitem.destroy
    
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
  end
end
