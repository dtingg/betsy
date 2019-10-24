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
    
  end
end
