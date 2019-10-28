class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :if_product_missing, only: [:show, :edit, :destroy]
  
  def index
    @products = Product.all.order(:name)
  end
  
  def show 
    add_to_recently_viewed(@product)
  end
  
  def new
    #come back to determine if this is the best logic for Product new
    if session[:user_id] != nil 
      @product = Product.new
    else
      not_authorized
    end  
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:failure] = "Product failed to save"
      render :new, status: :bad_request
      return
    end  
  end
  
  def edit 
    if session[:user_id]
      if @product.merchant_id != Merchant.find_by(id: session[:user_id]).id
        flash[:failure] = "A problem occurred: You cannot edit other merchants products."
        redirect_to product_path(id: @product.id) 
        return
      end
    else
      not_authorized
    end
  end
  
  def update
    if @product.update(product_params)
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:failure] = "Product failed to save"
      render :edit, status: :bad_request
      return
    end
  end
  
  def destroy
    if session[:user_id]
      @product.destroy
      redirect_to products_path
      return
    else
      not_authorized
    end
  end
  
  private
  
  def product_params
    return params.require(:product).permit(:name, :description, :active, :stock_qty, :price, :merchant_id, :photo_url, category_ids: [])
  end
  
  def find_product
    @product = Product.find_by(id: params[:id])
  end
  
  def if_product_missing
    if @product.nil?
      flash[:warning] = "Could not find product with id #{params[:id]}"
      redirect_to products_path 
      return
    end
  end

  def not_authorized
    flash[:failure] = "A problem occurred: You must log in to perform this action"
    redirect_back(fallback_location: products_path)
  end
end
