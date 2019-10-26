class ReviewsController < ApplicationController
  # before_action :find_review, only: [:show, :edit, :update, :destroy]
  # before_action :if_missing_review, only: [:show, :edit, :destroy]

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
        render :new, status: :bad_request 
        return
      end
    else 
      flash[:failure] = "A problem occurred: You cannot review your own product."
    end   
    redirect_to works_path
  end

  # def show ; end

  # def edit ; end

  # def update    
  #   if @review.update(review_params)
  #     redirect_to product_path(id: @review.product_id)
  #     return
  #   else 
  #     flash.now[:failure] = "Review failed to save"
  #     render :edit, status: :bad_request 
  #     return
  #   end
  # end

  # def destroy    
  #   @review.destroy
  #   redirect_to product_path(id: @review.product_id)
  #   return
  # end
  
  private
  
  def review_params
    return params.require(:review).permit(:comment, :rating, :reviewer, :product_id, :date)
  end

  # def find_review
  #   @review = Review.find_by(id: params[:id])
  # end

  # def if_missing_review
  #   if @review.nil?
  #     flash[:error] = "Review with id #{params[:id]} was not found"
  #     redirect_back(fallback_location: root_path)
  #     return
  #   end
  # end
end

