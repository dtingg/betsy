require "pry"

class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]
  before_action :if_merchant_missing, only: [:show]
  
  def index 
    @merchants = Merchant.all
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
  
  def edit 
  end
  
  def update 
  end
  
  
  
  # def index 
  #   @users = User.alphabetic
  # end
  
  # def show
  #   @user = User.find_by(id: params[:id])
  
  #   if @user.nil?
  #     redirect_to root_path
  #     return 
  #   end
  # end
  
  # def create
  #   auth_hash = request.env["omniauth.auth"]
  
  #   user = User.find_by(uid: auth_hash[:uid], provider: "github")
  #   if user
  #     # User was found in the database
  #     flash[:success] = "Logged in as returning user #{user.name}"
  #   else
  #     # User doesn't match anything in the DB
  #     # Attempt to create a new user
  #     user = User.build_from_github(auth_hash)
  
  #     if user.save
  #       flash[:success] = "Logged in as new user #{user.name}"
  #     else
  #       # Couldn't save the user for some reason. If we
  #       # hit this it probably means there's a bug with the
  #       # way we've configured GitHub. Our strategy will
  #       # be to display error messages to make future
  #       # debugging easier.
  #       flash[:error] = "Could not create new user account: #{user.errors.messages}"
  #       return redirect_to root_path
  #     end
  #   end
  
  #   # If we get here, we have a valid user instance
  #   session[:user_id] = user.id
  #   return redirect_to root_path
  # end
  
  
  
  # def current
  #   @current_user = User.find_by(id: session[:user_id])
  #   unless @current_user
  #     flash[:error] = "You must be logged in to see this page"
  #     redirect_to root_path
  #   end
  # end
  private
  
  def merchant_params
    return params.require(:merchant).permit(:uid, :username, :email)
  end
  
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end
  
  def if_merchant_missing
    puts "********* made it *********"
    if @merchant.nil?
      puts "MERCHANT WAS NIL"
      flash[:warning] = "Could not find merchant with id #{params[:id]}"
      redirect_to merchants_path 
      return
    end
    puts "MERCHANT WASNT NILL"
  end
end
