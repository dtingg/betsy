require "test_helper"

describe ReviewsController do
  let (:new_merchant) { Merchant.create(uid: 9999, username: "random", email: "email") }
  let (:new_product) { Product.create(name: "Test ", price: 10.00, merchant: new_merchant) }
  let (:new_review) { Review.new(product_id: new_product.id, rating: 5) }
  
  describe "guest user (not-authenticated)" do
    before do
      product = products(:potter)
        review_hash = {
          review:{
            product_id: product.id, 
            rating: 5,
          }
        }
    end
    describe "new" do
      it 'shows the form to add a review' do
        get new_product_review_path(new_product.id)
        must_respond_with :success
      end
    end

    describe "create" do 
      
      it "can create a new review" do 
        product = products(:potter)
        review_hash = {
          review:{
            product_id: product.id, 
            rating: 5,
          }
        }
  
        expect { 
          post product_reviews_path(product.id), params: review_hash
        }.must_differ "Review.count", 1
        
        must_respond_with :redirect
        must_redirect_to  product_path(id: product.id)     
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
  
  
  describe "authentication" do
    before do
    end
    # perform login 
    describe "create restrictions for merchants" do
      it "should not allow a merchant to review their own product" do
        # needs a test
      end

      it "should allow a merchant to review any product that is not theirs" do
        # needs a test
      end
    end
  end
end


  
  
