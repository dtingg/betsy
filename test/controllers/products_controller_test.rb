require "test_helper"

describe ProductsController do

  before do
    @merchant = Merchant.create(uid: 9999, username: "random", email: "email")
    @product = Product.create(name: "Test ", price: 10.00, merchant: @merchant)
  end

  let(:invalid_product_id) { -1 }

  describe "index" do
    it "responds with success when there are products" do
      get products_path

      must_respond_with :success
    end

    it "responds with success when there are no products" do
      @product.destroy

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "redirects to the details page of a valid product" do

      valid_product_id = @product.id

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
          merchant_id: @merchant.id
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
      get edit_product_path(@product.id)

      must_respond_with :success
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

      expect { 
        patch product_path(@product.id), params: product_updates
      }.wont_change "Product.count"

      updated_product = Product.find_by(id: @product.id)

      expect(updated_product.price).must_equal product_updates[:product][:price]

      must_respond_with :redirect
      must_redirect_to product_path(@product.id)
    end

    it "doesnt update product information with invalid information" do
      original_product_price = @product.price

      invalid_product_updates = {
        product: {
          price: nil
        }
      }

      expect { 
        patch product_path(@product.id), params: invalid_product_updates
      }.wont_change "Product.count"

      expect(flash.now[:failure]).must_equal "Product failed to save"
      expect(@product.price).must_equal original_product_price
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys product when given valid product id" do
      expect {
        delete product_path(@product.id)
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
