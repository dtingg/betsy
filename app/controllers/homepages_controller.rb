class HomepagesController < ApplicationController
before_action :blank_search, only: [:search]

  def search
    # word = params[:search].split(" ").first.capitalize
    @products = Product.where(name: params[:search])
    @merchants = Merchant.where(username: params[:search])
    if @products == [] && @merchants == [] 
      flash[:failure] = "No match"
      redirect_to root_path
      return 
    end
  end
end

private
def blank_search
  if params[:search].blank?
    redirect_to(root_path, alert: "Empty field!") and return    
  def index
    @products = Product.highlight
  end
end
