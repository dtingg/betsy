class ReviewsController < ApplicationController
  before_action :validate_merchant

  def new
    @review = Review.new()
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Review was succesfully posted"
      
      redirect_to product_path(id: @review.product_id)
      return
    else 
      flash[:failure] = "A problem occurred"

      render :new, status: :bad_request 
      return
    end  
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:comment, :rating, :reviewer, :product_id, :date)
  end

  def validate_merchant
    if session[:user_id]
      @product = Product.find_by(id: params[:product_id]) 
      merchant = Merchant.find_by(id: session[:user_id])

      if @product.merchant == merchant
        flash[:failure] = "A problem occurred: You cannot review your own product."

        redirect_to product_path(id: @product.id) 
        return 
      end
    end 
  end 

end

