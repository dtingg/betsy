class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end
  
  def show 
    review_id = params[:id]
    @review = Review.find_by(id: review_id)
    
    if @review.nil?
      flash[:error] = "Review Not Found"
      render reviews_path
    end
    
  end
  
  def create
    @review = Review.new(review_params)
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:product_id, :comment, :rating, :date, :reviewer)
  end
end

