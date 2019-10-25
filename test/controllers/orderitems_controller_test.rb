require "test_helper"

describe OrderitemsController do
  describe "create" do
    it "does not create an orderitem if the form data is nil, and responds with redirect" do
      orderitem_hash = { orderitem: nil }
      
      expect { post orderitems_path, params: orderitem_hash }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "can create a new orderitem with valid information accurately, and redirect" do
      test_order = Order.create(status: "pending")
      test_merchant = Merchant.create
      test_product = Product.create(merchant_id: test_merchant.id, name: "Oatmeal soap", price: 5.55)
      
      orderitem_hash = { orderitem: { order_id: test_order.id, product_id: test_product.id, quantity: 3 }}
      
      expect { post orderitems_path, params: orderitem_hash }.must_change "Orderitem.count", 1
      
      new_orderitem = Orderitem.last
      
      expect(new_orderitem.order_id).must_equal orderitem_hash[:orderitem][:order_id]
      expect(new_orderitem.product_id).must_equal orderitem_hash[:orderitem][:product_id]
      expect(new_orderitem.quantity).must_equal orderitem_hash[:orderitem][:quantity]
      expect(flash[:success]).must_equal "Item added to your cart"
      must_respond_with :redirect  
    end
    
    it "will not create a new orderitem if a required field is missing" do
      test_order = Order.create(status: "pending")
      test_merchant = Merchant.create
      test_product = Product.create(merchant_id: test_merchant.id, name: "Oatmeal soap", price: 5.55)
      
      orderitem_hash = { orderitem: { order_id: test_order.id, product_id: test_product.id, quantity: nil }}
      
      expect { post orderitems_path, params: orderitem_hash }.wont_change "Orderitem.count", 1
      
      expect(flash[:error]).must_equal "Error adding product to your cart"
      must_respond_with :redirect
    end      
  end
end
