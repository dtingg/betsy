class ApplicationController < ActionController::Base
  before_action :find_cart
  
  private
  
  def find_cart
    if session[:order_id]
      @cart = Order.find_by(id: session[:order_id])
    end
    
    if @cart.nil?
      @cart = Order.create(status: "pending")
      session[:order_id] = @cart.id
    end
  end
end
