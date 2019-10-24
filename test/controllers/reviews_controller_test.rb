require "test_helper"

describe ReviewsController do
  describe "index" do
    it "should display all reviews" do
      get reviews_path 
      must_respond_with :success
    end
    
    it "should not break if there are no reviews" do 
      Review.destroy_all
      get reviews_path
      must_respond_with :success
    end
  end
  
  describe "show" do
    
    it "should respond with success when given a valid review" do
      review_one = reviews(:review_one)
      
      get review_path(review_one.id)
      must_respond_with :success
    end
    
    it "should respond with redirect with an invalid review" do 
      get review_path(-1)
      must_redirect_to products_path
    end
  end
  
  describe "create" do
    
    it "can create a new review" do
      new_review_params = {
        review: {
          product_id: 999,
          reviewer: "Evelyn Boyd Granville",
          date: Time.now,
          rating: 5,
          comment: "Love the scent and it just looks so cute!"
        }
      }
      
      expect { post reviews_path, params: new_review_params }.must_change "Review.count", 1
      
      new_review = Review.find_by(id: new_review_params[:review][:id])
      
      expect(new_review.reviewer).must_equal new_review_params[:review][:reviewer]
      
      must_respond_with :redirect
      must_redirect_to review_path(new_review)
      
    end
  end
end

