class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :if_product_missing, only: [:show, :edit, :destroy]

  def index
    @products = Product.all
  end

  def show ; end

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
      return
    end
  end

  def edit ; end

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
end
