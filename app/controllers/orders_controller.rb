class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])    
  end
  
  def edit
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
  end
  
  def update
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.update(order_params)
      flash[:success] = "Thank you for your order!"  
      redirect_to order_path(@order)
      session[:order_id] = nil
      return
    else
      render :edit
      return
    end
  end
  
  def cart
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:status, :name, :email, :address, :city, :state, :zipcode, :cc_num, :cc_exp, :cc_cvv, :order_date, :merchant_id)
  end  
end