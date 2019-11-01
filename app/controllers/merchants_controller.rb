class MerchantsController < ApplicationController
  def index 
    @merchants = Merchant.alphabetic
  end
  
  def show
    @merchant = Merchant.find_by(id: params[:id])
    
    if @merchant.nil?
      flash[:redirect] = "Could not find merchant with id #{params[:id]}"
      
      redirect_to merchants_path 
      return
    end
  end
  
  def dashboard
    @merchant = Merchant.find_by(id: session[:user_id])
    
    if @current_user.nil?
      flash[:failure] = "A problem occurred: You are not authorized to perform this action"
      
      redirect_to root_path
      return
    end
  end
  
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
    return redirect_to dashboard_path
  end
  
  def logout
    session[:user_id] = nil
    @current_user = nil
    flash[:success] = "Successfully logged out"
    
    redirect_to root_path
    return
  end
  
  private
  
  def merchant_params
    return params.require(:merchant).permit(:uid, :username, :email)
  end
end
