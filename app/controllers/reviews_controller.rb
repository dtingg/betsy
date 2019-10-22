class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:product_id, :comment, :rating, :date, :reviewer)
  end
  
  