class CategoriesController < ApplicationController
  
  before_action :valid_category?, only: [:show]
  def index
    @categories = Category.all
  end

  def show; end

  private
  def category_params
   
    return params.require(:category).permit(:name, product_ids: [])
  end

  def valid_category?
    @category = Category.find_by(id: params[:id])
    if @category.nil? 
      flash[:error] = "category doesn't exist"
      redirect_to categories_path
    end
  end
end
