class ApplicationController < ActionController::Base
  before_action :find_cart
  
  def index
    @categories = Category.all
  end
  
  private
  
  def find_cart
    if session[:cart_id]
      @cart = Order.find_by(id: session[:cart_id])
    end
    
    if @cart.nil?
      @cart = Order.create(status: "pending")
      session[:cart_id] = @cart.id
      session[:recently_viewed] = Array.new
    end
    
    current_user
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
