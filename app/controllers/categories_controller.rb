class CategoriesController < ApplicationController
  
  before_action :valid_category?, only: [:show]
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(name: params[:category][:name])

    if @category.save
      redirect_to category_path(@category.id)
      return
    else
      flash.now[:failure] = "Category failed to save"
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name, :product_id)
  end

  def valid_category?
    @category = Category.find_by(id: params[:id])
    if @category.nil? 
      flash[:error] = "category doesn't exist"
      redirect_to categories_path
    end
  end
end
