class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:failure] = "Product failed to save"
      render :new, status: :bad_request
    end
  end


  private

  def product_params
    return params.require(:product).permit(:name, :description, :active, :stock_qty, :price, :merchant_id, :photo_url)
  end
  
end
