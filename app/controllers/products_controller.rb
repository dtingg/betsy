class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :if_product_missing, only: [:show, :edit, :update, :destroy]
  before_action :find_merchant, only: [:edit, :update, :destroy]
  
  def index
    @products = Product.all.order(:name)
    @categories = Category.all.order(:name)
  end
  
  def show 
    # adds product to recently viewed array
    @recent = session[:recently_viewed]

    if @recent.include?(@product.id) == false
      @recent.insert(0, @product.id)
    end 
    
    if @recent.length > 5
      @recent.delete_at(-1)
    end
    
    session[:recently_viewed] = @recent
  end
  
  def new
    if @current_user
      @product = Product.new
    else
      flash[:failure] = "A problem occurred: You must log in to perform this action"

      redirect_back(fallback_location: products_path)
      return
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
  
  def edit; end
  
  def update
    if @product.update(product_params)
      # redirect_to dashboard_path(@current_user.id)
      redirect_to dashboard_path
      return
    else
      flash.now[:failure] = "Product failed to save"
      render :edit, status: :bad_request
      return
    end
  end
  
  def destroy
    session[:recently_viewed].delete(@product.id)
    @product.destroy

    redirect_to products_path
    return
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

  def find_merchant
    merchant = @product.merchant
  
    if merchant.nil?
      flash[:failure] = "Could not find merchant for this product"
      redirect_to merchants_path 
      return
    end
      
    if @current_user != merchant
      flash[:failure] = "A problem occurred: You are not authorized to perform this action"

      redirect_to products_path
      return
    end
  end
end
