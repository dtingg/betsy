require "test_helper"

describe Order do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com", uid: "12346") }
  let (:oatmeal_soap) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.50, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg") }
  let (:lemon_soap) { Product.create(merchant_id: merchant.id, name: "Lemon soap", price: 1.50, photo_url: "https://res.cloudinary.com/hbmnvixez/image/upload/v1572551624/generic.jpg") }
  let (:order) { Order.create(status: "pending", name: "Fred Flintstone", email: "fred@aol.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new ) }  
  let (:new_order) { Order.create(status: "pending")}
  let (:orderitem_one) { Orderitem.create(order_id: order.id, product_id: oatmeal_soap.id, quantity: 1) }
  let (:orderitem_two) { Orderitem.create(order_id: order.id, product_id: lemon_soap.id, quantity: 2) }
  let (:orderitem_two) { Orderitem.create(order_id: order.id, product_id: lemon_soap.id, quantity: 2, complete: true) }
  
  describe "total method" do
    it "returns the correct total for an order with no orderitems" do
      result = new_order.total
      
      expect(result).must_equal 0
    end
    
    it "returns the correct total for an order with one orderitem" do
      order.save
      orderitem_one.save
      
      result = order.total
      expected_result = orderitem_one.quantity * orderitem_one.product.price
      
      expect(result).must_equal expected_result
    end
    
    it "returns the correct total for an order with multiple orderitems" do
      order.save
      orderitem_one.save
      orderitem_two.save
      
      result = order.total
      expected_result = orderitem_one.quantity * orderitem_one.product.price + orderitem_two.quantity * orderitem_two.product.price
      
      expect(result).must_equal expected_result
    end
  end

  describe "check_status" do
    before do
      sample_order = Order.create(status: "pending", name: "Unique name", email: "fred@aol.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new)

      @order = Order.find_by(name: "Unique name" )

      @first_orderitem = Orderitem.create(order_id: @order.id, product_id: oatmeal_soap.id, quantity: 1, complete: false)

      @second_orderitem = Orderitem.create(order_id: @order.id, product_id: oatmeal_soap.id, quantity: 1, complete: true)
    end

    it "will not mark order as complete if all orderitems are not marked complete" do
      expect(@order.status).must_equal "pending"

      @order.check_status

      expect(@order.status).must_equal "pending"
    end

    it "will mark an order as complete if all orderitems are marked complete" do
      expect(@order.status).must_equal "pending"

      @first_orderitem.update(complete: true)

      @order.check_status

      expect(@order.status).must_equal "complete"
    end

    it "will mark order as cancelled if all orderitems are marked cancelled" do
      expect(@order.status).must_equal "pending"

      @first_orderitem.update(complete: nil)
      @second_orderitem.update(complete: nil)

      @order.check_status

      expect(@order.status).must_equal "cancelled"
    end

    it "will not mark order as cancelled unless all orderitems are marked cancelled" do
      expect(@order.status).must_equal "pending"

      @first_orderitem.update(complete: nil)
      @second_orderitem.update(complete: false)

      @order.check_status
      
      expect(@order.status).must_equal "pending"
    end
  end
end
