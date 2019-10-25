require "test_helper"

describe Product do
  let (:merchant) { Merchant.create }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.55) }
  
  describe "update qty method" do
    it "updates quantity correctly when adding items to a cart" do
      product.update_qty(3)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 7
    end
    
    it "updates quantity correctly when deleting items from a cart" do
      product.update_qty(-2)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 12
    end
  end
end
