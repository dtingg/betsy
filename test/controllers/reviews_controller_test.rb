require "test_helper"

describe ReviewsController do
  let (:new_merchant) { Merchant.create(uid: 9999, username: "random", email: "email") }
  let (:new_product) { Product.create(name: "Test ", price: 10.00, merchant: new_merchant) }
  let (:new_review) { Review.new(product_id: new_product.id, rating: 5) }
  
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

  describe "show" do 
    it "should respond with success when given a valid review" do 
      new_review.save
     
      get product_review_path(product_id: new_product.id, id: new_review.id)
    
      must_respond_with :success
    end
    
    it "should respond with redirect with an invalid review" do 

      invalid_id = -1
      
      get product_review_path(product_id: new_product.id, id: invalid_id)
    
      must_respond_with :redirect
      expect(flash[:error]).wont_be_nil
    end
  end

  describe "show" do 
    it "should respond with success when given a valid review" do 
      new_review.save
     
      get product_review_path(product_id: new_product.id, id: new_review.id)
    
      must_respond_with :success
    end
    
    it "should respond with redirect with an invalid review" do 
      invalid_id = -1
      
      get product_review_path(product_id: new_product.id, id: invalid_id)
    
      must_respond_with :redirect
      expect(flash[:error]).wont_be_nil
    end
  end

  describe "edit" do
    it "will show edit page for valid review" do
      new_review.save

      get  edit_product_review_path(product_id: new_product.id, id: new_review.id)

      must_respond_with :success
    end

    it "will redirect if given invalid review ID" do
      invalid_id = -1

      get  edit_product_review_path(product_id: new_product.id, id: invalid_id)

      must_respond_with :redirect
      expect(flash[:error]).wont_be_nil  
    end
  end

  describe "update" do
    it "will update a review" do
  
      new_review.save
      updated_review = {
        review: {
          rating: 2,
        }
      }

      expect { 
        put product_review_path(product_id: new_product.id, id: new_review.id), params: updated_review
      }.wont_change "Review.count"
      
      must_respond_with :redirect
      must_redirect_to  product_path(id: new_product.id) 
      expect(Review.find_by(id: new_review.id).rating).must_equal 2
      expect(Review.find_by(id: new_review.id).product_id).must_equal new_product.id
    end

    it "will not update a review when invalid information is provided" do
      new_review.save
      updated_review = {
        review: {
          rating: nil,
        }
      }

      expect { 
        put product_review_path(product_id: new_product.id, id: new_review.id), params: updated_review
      }.wont_change "Review.count"
      
      must_respond_with :bad_request 
      expect(flash[:failure]).wont_be_nil
    end
  end

  describe "destroy" do
    it "destroys a review" do
      new_review.save

      expect {
        delete product_review_path(product_id: new_product.id, id: new_review.id)
      }.must_differ "Review.count", -1

      must_respond_with :redirect
      must_redirect_to product_path(id: new_product.id)
    end

    it "will not destroy a review if invalid id is provided" do
      invalid_id = -1

      expect {
        delete product_review_path(product_id: new_product.id, id: invalid_id = -1)
      }.wont_change "Review.count"

      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:error]).wont_be_nil
    end
  end
end


  
  
