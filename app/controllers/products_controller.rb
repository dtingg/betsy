class ProductsController < ApplicationController

  private


  # need to add merchant_id
  def product_params
    return params.require(:product).permit(:name, :description, :active, :stock_qty, :price)
  end

end
