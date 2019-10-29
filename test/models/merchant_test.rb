require "test_helper"

describe Merchant do
  
  describe "Member Since Method" do
    # it "can calculate how long a merchant has been a member" do
    #   @merchant = merchants(:merchant_two)
    #   expect((Time.current - @merchant.created_at).to_i).must_equal (@merchant.member_since).to_i
    # end
  end
  
  describe "Active Products Methods" do
    it "counts when a merchant has active products" do
      @merchant = merchants(:merchant_two)
      expect((@merchant.products.where(active: true)).count.to_s).must_equal @merchant.active_products.slice(0)
    end
    
    it "counts when a merchant doesn't have any active products" do
      @merchant = merchants(:merchant_one)
      expect((@merchant.products.where(active: true)).count.to_s).must_equal @merchant.active_products.slice(0)
    end
  end
  
  describe "build from github" do
    it "can build an auth_hash from github" do
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
      expected_average = 0

      average_rating = merchant_three.calculate_average_rating

      expect(average_rating).must_equal expected_average
    end
  end  
end
