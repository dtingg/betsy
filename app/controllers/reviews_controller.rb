class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end
  
  def create
    @review = Review.new(review_params)
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:product_id, :comment, :rating, :date, :reviewer)
  end
end

