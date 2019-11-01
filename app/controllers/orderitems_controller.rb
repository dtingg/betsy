class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:edit, :update, :destroy]
  
  def create
    if params[:orderitem].nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    # Look for existing orderitem for this order
    @orderitem = Orderitem.exists?(params[:orderitem][:order_id], params[:orderitem][:product_id])
    
    # Check if desired quantity is in stock and that product is active
    if @orderitem
      status = @orderitem.check_qty(params[:orderitem][:quantity])
      
      if status == false
        flash[:error] = "Product not in stock at the requested amount"
        redirect_back(fallback_location: root_path)
        return
      end
    end
    
    # If it exists, update the quantity
    if @orderitem
      @orderitem.increase_qty(params[:orderitem][:quantity])
      redirect_back(fallback_location: root_path)
      flash[:success] = "Item quantity updated"
      return
      # Else create a new one
    else
      @orderitem = Orderitem.create(orderitem_params)
    end
    
    if @orderitem.save
      @orderitem.product.remove_stock(@orderitem.quantity)  
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
      #   # This is for updating quantity in shopping cart view
      # elsif @orderitem.mark_complete
      #   @orderitem.mark_complete
      
    elsif @orderitem.update(orderitem_params)
      if @orderitem.complete == true
        flash[:success] = "Product Order Completed"
        redirect_back(fallback_location: root_path)
        return  
      end
      if @orderitem.complete == nil
        flash[:success] = "Product Cancelled"
        redirect_back(fallback_location: root_path)
        return  
      end
      
      difference = @orderitem.quantity - params[:old_quantity].to_i
      
      if difference > 0
        @orderitem.product.remove_stock(difference)
      elsif difference < 0 
        @orderitem.product.return_stock(-difference)
      end
      
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
      flash[:error] = "Unable to remove item from cart"
      redirect_back(fallback_location: root_path)
      return
    else
      @orderitem.remove_from_cart    
      flash[:success] = "Item removed from your cart"  
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
  end
  
  def orderitem_params
    return params.require(:orderitem).permit(:quantity, :order_id, :product_id, :complete, :old_quantity)
  end
end
