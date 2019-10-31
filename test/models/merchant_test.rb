require "test_helper"

describe Merchant do
  describe "initialize" do
    before do
      @new_merchant = Merchant.new(username: "random", uid: 32132, email: "random@email")
    end
    
    it "can be instantiated" do
      expect(@new_merchant.valid?).must_equal true
    end
    
    it "will have the required fields" do
      [:username, :uid, :email].each do |field|
        expect(@new_merchant).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    describe "product" do
      before do
        @merchant = Merchant.new(username: "random", uid: 32132, email: "random@email")
      end
      
      it "can be created without product" do
        expect(@merchant.save).must_equal true
      end
      
      it "can have a product" do
        @merchant.save
        product = Product.create(name: "random soap", price: 10.0, merchant: @merchant, stock_qty: 9, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
        
        expect(@merchant.products.last).must_be_instance_of Product      
        expect(@merchant.products.last.name).must_equal product.name
      end
    end
  end
  
  describe "validations" do
    describe "username" do
      it "is valid with unique username" do
        unique_username = Merchant.new(username: "patricia", uid: 43242, email: "random@email.here")
        
        empty_hash = Hash.new
        
        expect(unique_username.valid?).must_equal true
        expect(unique_username.errors.messages).must_equal empty_hash
      end
      
      it "won't be created if username is not unique" do
        invalid_username = Merchant.new(username: "george", uid: 43242, email: "random@email.here")
        
        expect(invalid_username.valid?).must_equal false
        expect(invalid_username.errors.messages).must_include :username
        expect(invalid_username.errors.messages[:username]).must_equal ["has already been taken"]
      end
    end
    
    describe "email" do
      it "must have a unique email" do
        unique_email = Merchant.new(username: "patricia", uid: 43242, email: "random@email.here")
        
        empty_hash = Hash.new
        
        expect(unique_email.valid?).must_equal true
        expect(unique_email.errors.messages).must_equal empty_hash
      end
      
      it "won't be created if email is not unique" do
        invalid_email = Merchant.new(username: "hello_world", uid: 43242, email: "anemail@adadev.org")
        
        expect(invalid_email.valid?).must_equal false
        expect(invalid_email.errors.messages).must_include :email
        expect(invalid_email.errors.messages[:email]).must_equal ["has already been taken"]
      end
    end
    
    describe "uid" do
      it "must have a unique uid" do
        unique_uid = Merchant.new(username: "patricia", uid: 43242, email: "random@email.here")
        
        empty_hash = Hash.new
        
        expect(unique_uid.valid?).must_equal true
        expect(unique_uid.errors.messages).must_equal empty_hash
      end
      
      it "won't be created if uid is not unique" do
        invalid_uid = Merchant.new(username: "hello_world", uid: 1234, email: "afjdjklfda")
        
        expect(invalid_uid.valid?).must_equal false
        expect(invalid_uid.errors.messages).must_include :uid
        expect(invalid_uid.errors.messages[:uid]).must_equal ["has already been taken"]
      end
    end
  end
  
  describe "build from github" do
    it "can build an auth_hash from github" do
      auth_hash = { 
        uid: 12300,
        info: {
          email: "random@email.com",
          nickname: "random"
        }
      }
      
      new_merchant = Merchant.build_from_github(auth_hash)
      
      expect(new_merchant).must_be_kind_of Merchant
      
      expect(new_merchant.uid).must_equal auth_hash[:uid]
      expect(new_merchant.email).must_equal auth_hash[:info][:email]
      expect(new_merchant.username).must_equal auth_hash[:info][:nickname]
    end
  end
  
  describe "member since method" do
    it "can calculate how long a merchant has been a member" do
      merchant = merchants(:merchant_two)
      current_time = Time.current
      expected_duration = (((current_time - merchant.created_at) / 1.hour).round)
      
      expect(merchant.member_since.to_i).must_equal expected_duration
    end
    
    it "does not calculate membership duration if merchant not saved" do
      merchant = Merchant.new(username: "r", uid: 12321, email: "email@email.com")
      
      expect(merchant.member_since).must_equal "Date unknown"
    end
  end
  
  describe "all orderitems" do
    before do
      @merchant = merchants(:merchant_one)
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      order_one = Order.create(status: "pending")
      orderitem_one = Orderitem.create(order_id: order_one.id, product_id: product.id, quantity: 3)
      
      order_two = Order.create(status: "pending")
      orderitem_two = Orderitem.create(order_id: order_two.id, product_id: product.id, quantity: 2)
      
      merchant_two = merchants(:merchant_two)
      product_two =  Product.create(merchant_id: merchant_two.id, name: "Rose soap", price: 5.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      order_three = Order.create(status: "pending")
      orderitem_three = Orderitem.create(order_id: order_three.id, product_id: product_two.id, quantity: 3)
    end
    
    it "returns all order items related to the specific merchant" do
      id = @merchant.id
      
      orderitems = @merchant.all_orderitems
      
      expect(orderitems.length).must_equal 2
      
      orderitems.each do |orderitem|
        expect(orderitem.product.merchant).must_be_kind_of Merchant
        expect(orderitem.product.merchant_id).must_equal id
      end
    end
    
    it "returns empty array if there are no orders related to specific merchant" do
      empty_orderitems_list = merchants(:merchant_three).all_orderitems
      
      expect(empty_orderitems_list).must_equal []
    end
  end
  
  describe "active products method" do
    before do
      @merchant = merchants(:merchant_two)
    end
    
    it "counts when a merchant has active products" do
      expect(@merchant.active_products).must_equal (@merchant.products.where(active: true)).count
    end
    
    it "counts when a merchant doesn't have any active products" do
      expect(@merchant.active_products).must_equal @merchant.active_products
    end
  end
  
  describe "alphabetize" do
    it "can alphabetically sort" do
      @merchants = merchants(:merchant_one, :merchant_two, :merchant_three)
      
      @merchants.shuffle
      
      Merchant.alphabetic
      
      expect(@merchants[0].username < @merchants[1].username).must_equal true
      expect(@merchants[1].username < @merchants[2].username).must_equal true
    end
    
    it "if no merchants, returns empty array" do
      Merchant.destroy_all
      
      expect(Merchant.alphabetic).must_equal [] 
    end
  end
  
  describe "calculate total revenue" do
    before do
      @merchant = Merchant.create(username: "golden merchant", uid: 1232, email: "hello@world.com")
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      @order_one = Order.create(status: "pending")
      orderitem_one = Orderitem.create(order_id: @order_one.id, product_id: product.id, quantity: 3)
      
      @order_two = Order.create(status: "pending")
      orderitem_two = Orderitem.create(order_id: @order_two.id, product_id: product.id, quantity: 2)
      
      another_merchant = Merchant.create(username: "new merch", uid: 1232132, email: "email@world.com")
      product_two =  Product.create(merchant_id: another_merchant.id, name: "Rose soap", price: 5.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      order_three = Order.create(status: "pending")
      orderitem_three = Orderitem.create(order_id: order_three.id, product_id: product_two.id, quantity: 3)
    end
    
    it "calculates the total revenue for a merchant with multiple orders" do
      expected_sum = @order_one.total + @order_two.total
      
      total_revenue = @merchant.calculate_total_revenue("all")
      
      expect(total_revenue).must_equal expected_sum
    end
    
    it "calculates total revenue for a merchant with no orders" do
      merchant_three = merchants(:merchant_three)
      expected_sum = 0
      
      total_revenue = merchant_three.calculate_total_revenue("all")
      
      expect(total_revenue).must_equal expected_sum
    end
  end
  
  describe "calculate total revenue" do
    before do
      @merchant = Merchant.create(username: "golden merchant", uid: 1232, email: "hello@world.com")
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      @order_one = Order.create(status: "pending")
      orderitem_one = Orderitem.create(order_id: @order_one.id, product_id: product.id, quantity: 3)
      
      @order_two = Order.create(status: "pending")
      orderitem_two = Orderitem.create(order_id: @order_two.id, product_id: product.id, quantity: 2)
      
      another_merchant = Merchant.create(username: "new merch", uid: 1232132, email: "email@world.com")
      product_two =  Product.create(merchant_id: another_merchant.id, name: "Rose soap", price: 5.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg")
      order_three = Order.create(status: "pending")
      orderitem_three = Orderitem.create(order_id: order_three.id, product_id: product_two.id, quantity: 3)
    end
    
    it "calculates the total revenue for a merchant with multiple orders" do
      expected_sum = 2
      
      order_count = @merchant.calculate_order_count("all")
      
      expect(order_count).must_equal expected_sum
    end
    
    it "calculates total revenue for a merchant with no orders" do
      merchant_three = merchants(:merchant_three)
      expected_sum = 0
      
      order_count = merchant_three.calculate_order_count("all")
      
      expect(order_count).must_equal expected_sum
    end
  end
  
  describe "calculate average rating" do
    
    let(:merchant) { Merchant.create(username: "golden merchant", uid: 1232, email: "hello@world.com") }
    let(:product) { Product.create(merchant: merchant, name: "Oatmeal soap", price: 6.00, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg") }
    
    
    
    it "calculates average rating for merchant with multiple reviews" do
      review_one = Review.create(comment: "blah blah", product_id: product.id, rating: 4, date: Time.now, reviewer: "hello") 
      review_two = Review.create(comment: "nothing", product_id: product.id, rating: 2, date: Time.now, reviewer: "natalie") 
      expected_average = ((review_one.rating + review_two.rating) / 2.0)
      
      expect(merchant.calculate_average_rating).must_equal expected_average
    end
    
    it "calculates average rating for merchant with no reviews" do
      merchant_three = merchants(:merchant_three)
      
      average_rating = merchant_three.calculate_average_rating
      
      assert_nil(average_rating)
    end
  end  
  
  describe "date_formatting method" do
    it "will take the time off of the date object" do
      test_date = Time.now
      formatted_date = Merchant.date_formatting(Time.now)
      expect(formatted_date).wont_be_instance_of Time
      expect(formatted_date).wont_include ":"
    end
  end
end
