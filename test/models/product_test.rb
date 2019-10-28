require "test_helper"

describe Product do
  describe "initialize" do
    before do
      @new_product = Product.new(name: "random soap", price: 10.0, merchant: merchants(:merchant_one), stock_qty: 9)

    end
    it "can be instantiated" do
      expect(@new_product.valid?).must_equal true
    end
    
    it "will have the required fields" do
      [:name, :description, :active, :stock_qty, :price, :merchant_id, :photo_url].each do |field|
        expect(@new_product).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    describe "merchant" do
      it "has a merchant" do
        product = products(:potter)
        
        expect(product.merchant).must_be_instance_of Merchant      
      end

      it "can set a merchant through 'merchant'" do
        product = Product.new(name: "cats cats cats", price: 10.0, stock_qty: 9)

        product.merchant = merchants(:merchant_two)

        expect(product.merchant_id).must_equal merchants(:merchant_two).id
      end

      it "can set a merchant through 'merchant_id'" do
        product = Product.new(name: "dogs dogs dogs", price: 10.0, stock_qty: 9)

        product.merchant_id = merchants(:merchant_two).id

        expect(product.merchant).must_equal merchants(:merchant_two)
      end
    end

    describe "categories" do
      it "has one or many categories" do
        potter = products(:potter)
        
        expect(potter.categories.count).must_equal products(:potter).categories.count

        rose = products(:rose)

        expect(rose.categories.count).must_equal products(:rose).categories.count
      end

      it "can set a category through 'category" do
        product = Product.new(name: "cats cats cats", price: 10.0, stock_qty: 9)

        product.categories << categories(:organic)

        product.categories.last.id.must_equal categories(:organic).id
      end

      it "can set a category through category_id" do
        product = Product.new(name: "dogs dogs dogs", price: 10.0, stock_qty: 9)

        product.categories << categories(:organic)

        product.categories.last.must_equal categories(:organic)
      end
    end
  end
  
  describe "validations" do
    it "must have a name" do
      product = products(:potter)
      product.name = nil
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :name
      expect(product.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "must have a unique name" do      
      duplicate_product = Product.create(merchant_id: merchants(:merchant_one), name: "harry potter soap", price: 4) 
      
      expect(duplicate_product.valid?).must_equal false
      expect(duplicate_product.errors.messages).must_include :name
      expect(duplicate_product.errors.messages[:name]).must_equal ["has already been taken"]
    end
    
    it "must have a price" do
      product = products(:potter)
      product.price = nil
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
    end
    
    it "must have a price greater than 0" do
      product = products(:potter)
      product.price = 0
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
      expect(product.errors.messages[:price]).must_equal ["must be greater than 0"]
    end
    
    it "must have a merchant_id" do
      product = products(:potter)
      product.merchant_id = nil
      
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :merchant_id
      expect(product.errors.messages[:merchant_id]).must_equal ["can't be blank"]
    end
  end
  
  describe "remove stock method" do
    it "decreases quantity of an item correctly" do
      product = products(:rose)
      product.remove_stock(3)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 7
    end

    it "does nothing if given negative stock to remove" do
      product = products(:rose)
      product.remove_stock(0)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 10
    end
  end
  
  describe "return stock method" do
    it "increases quantity of an item correctly" do
      product = products(:rose)
      product.return_stock(2)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 12
    end

    it "does nothing if given negative stock to return" do
      product = products(:rose)
      product.return_stock(0)
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal 10
    end
  end

  describe "self.order_active_products" do
    it "sorts list of active products by name" do    
      sorted_products = Product.order_active_products
      
      sorted_products.each do |product|
        expect(product.active).must_equal true
      end
      expect(sorted_products.first.name).must_equal "cucumber"
      expect(sorted_products.last.name).must_equal "rose soap"

    end

    it "if no active products, returns an empty array" do
      Product.destroy_all

      sorted_products = Product.order_active_products

      expect(sorted_products).must_equal []
    end
  end
end
