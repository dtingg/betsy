class HomepagesController < ApplicationController
before_action :blank_search, only: [:search]

  def index
    @products = Product.highlight
  end

  def search
    @products = Product.where(name: params[:search])
    @merchants = Merchant.where(username: params[:search])
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
