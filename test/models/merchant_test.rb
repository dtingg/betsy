require "test_helper"

describe Merchant do

  
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

      expect((merchant.member_since).to_i).must_equal ((Time.current - merchant.created_at).to_i)
    end

    it "does not calculate membership duration if merchant not saved" do
      merchant = Merchant.new(username: "r", uid: 12321, email: "email@email.com")

      expect(merchant.member_since).must_equal "Date unknown"
    end
  end

  describe "all orderitems" do
    before do
      @merchant = merchants(:merchant_one)
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00)
      order_one = Order.create(status: "pending")
      orderitem_one = Orderitem.create(order_id: order_one.id, product_id: product.id, quantity: 3)

      order_two = Order.create(status: "pending")
      orderitem_two = Orderitem.create(order_id: order_two.id, product_id: product.id, quantity: 2)

      merchant_two = merchants(:merchant_two)
      product_two =  Product.create(merchant_id: merchant_two.id, name: "Rose soap", price: 5.00)
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

  describe "calculate gross sales" do
    before do
      @merchant = merchants(:merchant_one)
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00)
      @order_one = Order.create(status: "pending")
      orderitem_one = Orderitem.create(order_id: @order_one.id, product_id: product.id, quantity: 3)

      @order_two = Order.create(status: "pending")
      orderitem_two = Orderitem.create(order_id: @order_two.id, product_id: product.id, quantity: 2)

      merchant_two = merchants(:merchant_two)
      product_two =  Product.create(merchant_id: merchant_two.id, name: "Rose soap", price: 5.00)
      order_three = Order.create(status: "pending")
      orderitem_three = Orderitem.create(order_id: order_three.id, product_id: product_two.id, quantity: 3)
    end

    it "calculates the gross sales for a merchant with multiple orders" do
      expected_sum = @order_one.total + @order_two.total

      gross_sales = @merchant.calculate_gross_sales

      expect(gross_sales).must_equal expected_sum
    end

    it "calculates gross sales for a merchant with no orders" do
      merchant_three = merchants(:merchant_three)
      expected_sum = 0

      gross_sales = merchant_three.calculate_gross_sales

      expect(gross_sales).must_equal expected_sum
    end
  end

  describe "calculate average rating" do
    before do
      @merchant = merchants(:merchant_one)
      product =  Product.create(merchant_id: @merchant.id, name: "Oatmeal soap", price: 6.00)
      @review_one = Review.create(comment: "blah blah", product_id: product.id, rating: 4)
      @review_two = Review.create(comment: "nothing", product_id: product.id, rating: 2)
    end

    it "calculates average rating for merchant with multiple reviews" do
      average_rating = @merchant.calculate_average_rating

      expected_average = (@review_one.rating + @review_two.rating)/2

      expect(average_rating).must_equal expected_average

    end

    it "calculates average rating for merchant with no reviews" do
      merchant_three = merchants(:merchant_three)
      expected_average = nil

      average_rating = merchant_three.calculate_average_rating

      expect(average_rating).must_equal expected_average
    end
  end  
end
