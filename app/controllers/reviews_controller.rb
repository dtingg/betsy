class ReviewsController < ApplicationController

  def new
    @review = Review.new()
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find_by(id: params[:product_id])

    if @product.merchant_id != session[:merchant_id]
      if @review.save
        flash[:success] = "Review was succesfully posted"
        redirect_to product_path(id: @review.product_id)
        return
      else 
        flash[:failure] = "A problem occurred"
        render :new, status: :bad_request 
        return
      end
    else 
      flash[:failure] = "A problem occurred: You cannot review your own product."
    end   
    redirect_to works_path
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:comment, :rating, :reviewer, :product_id, :date)
  end

end

