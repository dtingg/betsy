require "test_helper"

describe ReviewsController do 
  let (:new_product) { products(:potter) }

  describe "guest user (not-authenticated)" do
    describe "new" do
      it 'can see the form to add a review' do
        get new_product_review_path(new_product.id)

        must_respond_with :success
      end
    end

    describe "create" do   
      it "can create a review" do 
        review_hash = {
          review:{
            product_id: new_product.id,
            reviewer: "Tiffany",
            rating: 5,
            comment: "Great!"
          }
        }
  
        expect { 
          post product_reviews_path(new_product.id), params: review_hash
        }.must_differ "Review.count", 1
        
        must_respond_with :redirect
        must_redirect_to product_path(id: new_product.id)     
      end
      
      it "will not create a new review if invalid fields are given" do 
        review_hash = {
          review:{
            reviewer: "Tiffany",
            product_id: new_product.id, 
            rating: nil,
            comment: nil
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
  
  describe "authenticated" do
    before do
      @merchant_product = Product.create(merchant_id: merchants(:merchant_three).id, name: "Soap", price: 10)
      @other_merchant_product = products(:rose) 

      perform_login(@user)
    end

    describe "new" do
      it "will not allow merchant to see new review form for their own product" do     
        get new_product_review_path(@merchant_product.id)
        
        must_redirect_to product_path(id: @merchant_product.id) 
        expect(flash[:failure]).wont_be_nil
      end

      it "will allow merchant to see new review form for products that are not their own" do
        get new_product_review_path(@other_merchant_product.id)
    
        must_respond_with :success 
      end
    end

    describe "create" do
      it "will not allow merchant to create a review for their own product" do 
        review_hash = {
          review:{
            reviewer: "Tiffany",
            product_id: @merchant_product.id,
            rating: 5,
            comment: "Great!"
          }
        }
  
        expect { 
          post product_reviews_path(@merchant_product.id), params: review_hash
        }.wont_change "Review.count"

        must_redirect_to  product_path(id: @merchant_product.id) 
        expect(flash[:failure]).wont_be_nil  
      end

      it "will allow merchant to create review for products that are not their own" do 
        review_hash = {
          review:{
            reviewer: "Tiffany",
            product_id: @other_merchant_product.id,
            rating: 5,
            comment: "Great!"
          }
        }
  
        expect { 
          post product_reviews_path(@other_merchant_product.id), params: review_hash
        }.must_differ "Review.count", 1

        must_redirect_to product_path(id: @other_merchant_product.id) 
        expect(flash[:success]).wont_be_nil  
      end
    end
  end
end
 

   
  
  
