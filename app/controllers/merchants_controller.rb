class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :dashboard, :destroy]
  before_action :if_merchant_missing, only: [:show, :dashboard, :destroy]
  before_action :if_invalid_merchant, only: [:dashboard, :destroy]
  
  def index 
    @merchants = Merchant.alphabetic
  end
  
  def show; end
  
  def dashboard;  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid])
    
    if merchant
      flash[:success] = "Logged in as returning merchant #{ merchant.username }"
      
    else
      merchant = Merchant.build_from_github(auth_hash)
      
      if merchant.save
        flash[:success] = "Logged in as new merchant #{ merchant.username }"
      else
        flash[:error] = "Could not create new merchant account: #{ merchant.errors.messages }"
        
        redirect_to merchants_path
        return 
      end
    end
    
    session[:user_id] = merchant.id
    redirect_to dashboard_path(session[:user_id])
  end
  
  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    
    redirect_to root_path
    return
  end
  
  def destroy
    @merchant.destroy
    
    redirect_to merchants_path
    return
  end
  
  private
  
  def merchant_params
    return params.require(:merchant).permit(:uid, :username, :email)
  end
  
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end
  
  def if_merchant_missing
    if @merchant.nil?
      flash[:redirect] = "Could not find merchant with id #{params[:id]}"
      redirect_to merchants_path 
      return
    end
  end
  
  def if_invalid_merchant
    if @current_user != @merchant
      flash[:failure] = "A problem occurred: You are not authorized to perform this action"
      
      redirect_to merchants_path
      return
    end
  end
end
