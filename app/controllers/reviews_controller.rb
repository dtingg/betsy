class ReviewsController < ApplicationController
  before_action :find_review, only: [:show, :edit, :update, :destroy]
  before_action :if_missing_work, only: [:show, :edit, :destroy]

  def index
    @reviews = Review.all
  end

  def create
    @review = Review.new(review_params)
  end
  
  def show ; end

  def edit ; end

  def update    
    if @review.update(review_params)
      # redirect_to review_path(@review.id) 
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def destroy    
    @review.destroy
    # redirect_to root_path
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
      redirect_to products_path
      #Shouldn't it be redirect_to root_path????
      return
    end
  end
end

