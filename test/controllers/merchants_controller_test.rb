require "test_helper"

describe MerchantsController do
  describe "index" do
    it "should display all merchants" do
      get merchants_path 
      must_respond_with :success
    end

    it "should not break if there are no merchants" do 
      Merchant.all.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do

    it "should respond with success when given a valid merchant" do
      merchant_one = merchants(:merchant_one)

      get merchant_path(merchant_one.id)
      must_respond_with :success
    end

    it "should respond with redirect with an invalid merchant" do 
      get merchant_path(-1)
      must_respond_with :not_found
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


end
