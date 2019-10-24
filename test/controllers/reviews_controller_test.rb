require "test_helper"

describe ReviewsController do
  let (:new_merchant) { Merchant.create(uid: 9999, username: "random", email: "email") }
  let (:new_product) { Product.create(name: "Test ", price: 10.00, merchant: new_merchant) }
  let (:new_review) { Review.create(product_id: new_product.id, rating: 5) }
  
  describe "show" do 
    it "should respond with success when given a valid review" do 
      new_review.save
     
      get product_review_path(product_id: new_product.id, id: new_review.id)
    
      must_respond_with :success
    end
    
    it "should respond with redirect with an invalid review" do 
      
      get product_review_path(product_id: new_product.id, id: -1)
    
      must_respond_with :redirect
    end
  end
  
  
end


  
  