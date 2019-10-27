class ApplicationController < ActionController::Base
  before_action :find_order
  
  private
  
  def find_order
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    end
    
    if @order.nil?
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end
  end
  
  def current_user
    if session[:user_id]
      @current_user = Merchant.find_by(id: session[:user_id])
    end
    
    if @current_user.nil?
      session[:user_id] = nil
    end
  end
end
