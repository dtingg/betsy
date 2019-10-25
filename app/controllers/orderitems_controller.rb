class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:destroy]
  
  def create
    # Orderitem.create(order_id: @cart.id, product_id: 7, quantity: 2)
    if params[:orderitem].nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    @orderitem = Orderitem.new(orderitem_params)
    
    if @orderitem.save
      flash[:success] = "Item added to your cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "Error adding product to your cart"
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  
  
  
  
  
  
  
  
  
  # def destroy
  #   @orderitem.destroy
  
  #   redirect_back(fallback_location: root_path)
  # end
  
  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
  end
  
  def orderitem_params
    return params.require(:orderitem).permit(:quantity, :order_id, :product_id, :complete)
  end
end
