class ReviewsController < ApplicationController
  before_action :find_review, only: [:show, :edit, :update, :destroy]
  before_action :if_missing_review, only: [:show, :edit, :destroy]

  # def index
  #   @reviews = Review.all
  # end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    
    if @review.save
      redirect_to product_path(id: @review.product_id)
      return
    else 
      flash.now[:failure] = "Work failed to save"
      render :new, status: :bad_request 
      return
    end
  end
  
  def show ; end

  def edit ; end

  def update    
    if @review.update(review_params)
      redirect_to product_path(id: @review.product_id)
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def destroy    
    @review.destroy
    redirect_to product_path(id: @review.product_id)
    return
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:product_id, :comment, :rating, :date, :reviewer)
  end

  def find_review
    @review = Review.find_by(id: params[:id])
  end

  def if_missing_review
    if @review.nil?
      flash[:error] = "Review with id #{params[:id]} was not found"
      redirect_to root_path
      return
    end
  end
end

