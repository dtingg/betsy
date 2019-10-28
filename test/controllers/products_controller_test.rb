require "test_helper"

describe ProductsController do
  let(:invalid_product_id) { -1 }
  
  describe "guest user (not authenticated)" do
    describe "index" do
      it "responds with success when there are products" do
        get products_path
        
        must_respond_with :success
      end
      
      it "responds with success when there are no products" do
        Product.destroy_all
        
        get products_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "redirects to the details page of a valid product" do
        valid_product_id = products(:cucumber)
        
        get product_path(valid_product_id)
        
        must_respond_with :success
      end
      
      it "redirects to products for invalid product id" do
        get product_path(invalid_product_id)
        
        expect(flash[:warning]).must_equal "Could not find product with id #{invalid_product_id}"
        
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "new" do
      it "does not show the form to create new product" do
        get new_product_path

        expect(flash[:failure]).must_equal "A problem occurred: You must log in to perform this action"

        must_respond_with :redirect
      end
    end

    describe "edit" do
      it "does not show the form to edit new product" do
        valid_product_id = products(:onion).id

        get edit_product_path(valid_product_id)

        expect(flash[:failure]).must_equal "A problem occurred: You must log in to perform this action"
        must_respond_with :redirect
      end
    end

    describe "destroy" do
      it "does not let guest user destroy product" do
        valid_product_id = products(:onion).id

        expect {
          delete product_path(valid_product_id)
        }.wont_change "Product.count"

        expect(flash[:failure]).must_equal "A problem occurred: You must log in to perform this action"

        must_respond_with :redirect
      end
    end
  end

  describe "authenticated user" do 
    before do
      new_merchant = Merchant.new(username:"Kathy", email: "whatev@git.com", uid: 473837 )
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merchant))

      get auth_github_callback_path
    end

    describe "new" do
      it 'shows the form to add a new product' do
        get new_product_path

        must_respond_with :success
      end
    end
    
    describe "create" do
      it "creates a new product given valid information" do      
        new_product = {
          product: {
            name: "Test2", 
            price: 10.00, 
            merchant_id: merchants(:merchant_three).id
          }
        }
        
        expect { 
          post products_path, params: new_product 
        }.must_differ "Product.count", 1
        
        created_product = Product.last
        
        expect(created_product.name).must_equal new_product[:product][:name]
        must_respond_with :redirect
        must_redirect_to product_path(created_product.id)
      end
      
      it "doesn't create a new product if given invalid information" do
        invalid_product = {
          product: {
            name: "Invalid product", 
            price: 10.00 
          }
        }
        
        expect { 
          post products_path, params: invalid_product
        }.wont_change "Product.count"
        
        expect(flash.now[:failure]).must_equal "Product failed to save"
        must_respond_with :bad_request
      end
    end

    describe "edit" do
      it "will show edit page for valid product" do
        valid_product_id = products(:rose).id

        get edit_product_path(valid_product_id)
        
        must_redirect_to product_path(id: valid_product_id) 
      end
      
      it "will redirect if given invalid product" do
        get edit_product_path(invalid_product_id)
        
        expect(flash[:warning]).must_equal "Could not find product with id #{invalid_product_id}"
        
        must_respond_with :redirect
        must_redirect_to products_path
      end
      
    end
    
    describe "update" do
      it "updates product information with valid information" do
        product_updates = {
          product: {
            price: 15.00 
          }
        }
        
        valid_product = products(:rose)
        valid_product_start_price = valid_product.price

        expect(products(:rose).price).must_equal valid_product_start_price

        expect { 
          patch product_path(valid_product.id), params: product_updates
        }.wont_change "Product.count"
        
        updated_product = Product.find_by(id: valid_product.id)
        
        expect(updated_product.price).must_equal product_updates[:product][:price]
        
        must_respond_with :redirect
        must_redirect_to product_path(valid_product.id)
      end
      
      it "doesn't update product information with invalid information" do
        original_product_price = products(:cucumber).price
        
        invalid_product_updates = {
          product: {
            price: nil
          }
        }
        
        expect { 
          patch product_path(products(:cucumber).id), params: invalid_product_updates
        }.wont_change "Product.count"
        
        expect(flash.now[:failure]).must_equal "Product failed to save"
        expect(products(:cucumber).price).must_equal original_product_price
        must_respond_with :bad_request
      end
    end
    
    describe "destroy" do
      it "destroys product when given valid product id" do
        valid_product_id = products(:rose).id

        expect {
          delete product_path(valid_product_id)
        }.must_differ "Product.count", -1
        
        must_respond_with :redirect
        must_redirect_to products_path
      end
      
      it "redirects when given invalid product id" do
        expect {
          delete product_path(invalid_product_id)
        }.wont_change "Product.count"
        
        
        expect(flash[:warning]).must_equal "Could not find product with id #{invalid_product_id}"
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end
  end
end
