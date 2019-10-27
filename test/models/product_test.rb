require "test_helper"

describe Product do
  let (:merchant) { Merchant.create(username: "buddy", email: "buddy@aol.com") }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Honey soap", price: 5.55) }
  
  describe "initialize" do
    it "can be instantiated" do
      expect(product.valid?).must_equal true
    end
    
    it "will have the required fields" do
      product.save
      
      [:name, :description, :active, :stock_qty, :price, :merchant_id, :photo_url].each do |field|
        expect(product).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    it "can have a merchant" do
      product.save
      
      expect(product.merchant).must_be_instance_of Merchant      
    end
  end
  
  describe "validations" do
    it "must have a name" do
      product.name = nil
      product.save
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :name
      expect(product.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "must have a unique name" do
      product.save
      
      duplicate_product = Product.create(merchant_id: merchant.id, name: "Honey soap", price: 4) 
      
      expect(duplicate_product.valid?).must_equal false
      expect(duplicate_product.errors.messages).must_include :name
      expect(duplicate_product.errors.messages[:name]).must_equal ["has already been taken"]
    end
    
    it "must have a price" do
      product.price = nil
      product.save
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
    end
    
    it "must have a price greater than 0" do
      product.price = 0
      product.save
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_equal ["must be greater than 0"]
    end
    
    it "must have a merchant_id" do
      product.merchant_id = nil
      product.save
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :merchant_id
      expect(product.errors.messages[:merchant_id]).must_equal ["can't be blank"]
    end
  end
  
  describe "remove stock method" do
    it "decreases quantity of an item correctly" do
      merchant.save
      product.remove_stock(3)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 7
    end
  end
  
  describe "return stock method" do
    it "increases quantity of an item correctly" do
      product.return_stock(2)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 12
    end
  end
end
