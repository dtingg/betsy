require "test_helper"

describe Product do
  let (:merchant) { Merchant.create(username: "buddy", email: "buddy@aol.com") }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Honey soap", price: 5.55) }
  
  describe "decrease qty method" do
    it "decreases quantity of an item correctly" do
      merchant.save
      product.decrease_qty(3)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 7
    end
  end
  
  describe "increase qty method" do
    it "increases quantity of an item correctly" do
      product.increase_qty(2)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 12
    end
  end
end
