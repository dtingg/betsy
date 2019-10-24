class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:error] = "Could not find product with id #{params[:id]}"
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
      return
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:error] = "Could not find product with id #{params[:id]}"
      redirect_to products_path
      return
    end
  end

  def update
    @product = Product.find_by(id: params[:id])

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
  end


  private

  def product_params
    return params.require(:product).permit(:name, :description, :active, :stock_qty, :price, :merchant_id, :photo_url)
  end
  
end
