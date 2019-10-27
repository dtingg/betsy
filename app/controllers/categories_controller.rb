class CategoriesController < ApplicationController

  private
  def category_params
   
    return params.require(:category).permit(:name, product_ids: [])
  end
end
