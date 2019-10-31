class HomepagesController < ApplicationController
  before_action :blank_search, only: [:search]
  
  def index
    @products = Product.highlight
  end
  
  def search
    # @products = Product.where(name: params[:search])
    @products = Product.where("lower(name) = ?", params[:search].downcase)
    @merchants = Merchant.where("lower(username) = ?", params[:search].downcase)
  end
  
  private
  def blank_search
    if params[:search].blank?
      flash[:failure] = "Empty field!" 
      redirect_back(fallback_location: root_path)
      return   
    end
  end 
end
