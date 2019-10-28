class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update]
  
  def show
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.status == "pending"
      redirect_to cart_path(@order)
      return
    end
  end
  
  def edit
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.status == "complete"
      redirect_to order_path(@order)
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
      session[:cart_id] = nil
      return
    else
      render :edit
      return
    end
  end
  
  def cart
  end
  
  private
  
  def find_order
    @order = Order.find_by(id: params[:id])
  end
  
  def order_params
    return params.require(:order).permit(:status, :name, :email, :address, :city, :state, :zipcode, :cc_num, :cc_exp, :cc_cvv, :order_date, :merchant_id)
  end  
end
