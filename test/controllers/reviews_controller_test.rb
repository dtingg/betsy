require "test_helper"

describe ReviewsController do
  let (:new_merchant) { Merchant.create(uid: 9999, username: "random", email: "email") }
  let (:new_product) { Product.create(name: "Test ", price: 10.00, merchant: new_merchant) }
  let (:new_review) { Review.new(product_id: new_product.id, rating: 5) }
  

  describe "new" do
    it 'shows the form to add a review' do
      get new_product_review_path(new_product.id)
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new review" do 
      review_hash = {
        review:{
          product_id: new_product.id, 
          rating: 5,
        }
      }

      expect { 
        post product_reviews_path(new_product.id), params: review_hash
      }.must_differ "Review.count", 1
      
      must_respond_with :redirect
      must_redirect_to  product_path(id: new_product.id)     
    end
    
    it "will will not create a new product if invalid fields are given" do 
      review_hash = {
        review:{
          product_id: new_product.id, 
          rating: nil,
        }
      }

      expect { 
        post product_reviews_path(new_product.id), params: review_hash
      }.wont_change "Review.count"
      
      expect(flash[:failure]).wont_be_nil
      must_respond_with :bad_request 
    end
  end
end


  
  
