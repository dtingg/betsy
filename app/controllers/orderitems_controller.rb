class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:edit, :update, :destroy]
  
  def create
    if params[:orderitem].nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    @orderitem = Orderitem.new(orderitem_params)
    
    if @orderitem.save
      @orderitem.product.decrease_qty(@orderitem.quantity)
      
      flash[:success] = "Item added to your cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "Error adding product to your cart"
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  def edit
    if @orderitem.nil?
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  def update
    if @orderitem.nil?
      redirect_back(fallback_location: root_path)
      return
    elsif @orderitem.update(orderitem_params)
      # @orderitem.product.update_qty(orderitem_params[:quantity])
      
      flash[:success] = "Product quantity updated"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "Unable to update product quantity"
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  
  
  def destroy
    if @orderitem.nil?
      flash[:error] = "Unable to remove item from cart."
      redirect_back(fallback_location: root_path)
      return
    end
    
    @orderitem.remove_from_cart    
    flash[:success] = "Item removed from your cart"  
    redirect_back(fallback_location: root_path)
    return
  end
  
  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
  end
  
  def orderitem_params
    return params.require(:orderitem).permit(:quantity, :order_id, :product_id, :complete)
  end
  
end