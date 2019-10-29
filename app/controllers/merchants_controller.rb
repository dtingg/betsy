class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :dashboard]
  before_action :if_merchant_missing, only: [:show, :dashboard]
  
  def index 
    @merchants = Merchant.alphabetic
  end
  
  def show; end
  
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
    return redirect_to merchants_path
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    
    redirect_to root_path
  end
  
  def update 
  end
  
  def dashboard; end
  
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
end
