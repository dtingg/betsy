class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find_by(id: params[:id])

    if @category.nil? 
      flash[:error] = "Category with id #{params[:id]} doesn't exist"

      redirect_to categories_path
      return
    end
  end

  def new
    if @current_user.nil?
      flash[:failure] = "You must log in to perform this action"

      redirect_to categories_path
      return
    end

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
end
