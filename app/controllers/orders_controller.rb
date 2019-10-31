class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :cart, :update]
  
  def show    
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.status == "pending"
      redirect_to cart_path
      return
    end

    verify_user
  end
  
  def edit
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end

    if @order.orderitems == [] || @order.orderitems.nil?
      redirect_to order_path(@order)
      return
    end

    if @order.status == "complete"
      redirect_to order_path(@order)
      return
    end
  end
  
  def update
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.update(order_params)
      cookies[:completed_order] = { value: "complete", expires: 1.minute }

      flash[:success] = "Thank you for your order!"  
      redirect_to order_path(@cart)
      session[:cart_id] = nil
      return
    else
      render :edit
      return
    end
  end
  
  def cart
    @order = Order.find_by(id: @cart.id)
    
    if @order.nil?
      redirect_to root_path
      return
    end
    
    if @order.status != "pending"
      redirect_to order_path(@order.id)
      return
    end
  end
  
  private
  
  def find_order
    @order = Order.find_by(id: params[:id])
  end
  
  def order_params
    return params.require(:order).permit(:status, :name, :email, :address, :city, :state, :zipcode, :cc_num, :cc_exp, :cc_cvv, :order_date, :merchant_id)
  end  

  def verify_user
    order_merchants = []
    @order.orderitems.each do |orderitem|
      product = orderitem.product
      merchant = product.merchant

      order_merchants << merchant.id
    end

    unless order_merchants.include?(session[:user_id]) || cookies[:completed_order]
      redirect_to root_path
      return
    end
  end
end
