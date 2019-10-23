require "test_helper"

describe ProductsController do

  before do
    merchant = Merchant.create(uid: 9999, username: "random", email: "email")
    @product = Product.create(name: "Test ", price: 10.00, merchant: merchant)
  end

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

    it "redirects to products for invalid product" do
      invalid_product_id = -1

      get product_path(invalid_product_id)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end
  
  describe "new" do


  end

  describe "create" do
  end

  describe "edit" do
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
