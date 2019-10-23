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
















  private

  # need to add merchant_id
  def product_params
    return params.require(:product).permit(:name, :description, :active, :stock_qty, :price, :merchant_id)
  end
  
end
