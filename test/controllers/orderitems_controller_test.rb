require "test_helper"

describe OrderitemsController do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com") }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.55) }
  let (:order) { Order.create(status: "pending") }
  let (:orderitem) { Orderitem.create(order_id: order.id, product_id: product.id, quantity: 3) }
  
  describe "create" do
    it "does not create an orderitem if the form data is nil, and responds with redirect" do
      orderitem_hash = { orderitem: nil }
      
      expect { post orderitems_path, params: orderitem_hash }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "can create a new orderitem with valid information accurately, updates product quantity, and redirects" do
      orderitem_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 3 }}
      previous_quantity = product.stock_qty
      
      expect { post orderitems_path, params: orderitem_hash }.must_change "Orderitem.count", 1
      
      new_orderitem = Orderitem.last
      expect(new_orderitem.order_id).must_equal orderitem_hash[:orderitem][:order_id]
      expect(new_orderitem.product_id).must_equal orderitem_hash[:orderitem][:product_id]
      expect(new_orderitem.quantity).must_equal orderitem_hash[:orderitem][:quantity]
      
      updated_quantity = previous_quantity - orderitem_hash[:orderitem][:quantity]
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal updated_quantity
      
      expect(flash[:success]).must_equal "Item added to your cart"
      must_respond_with :redirect  
    end
    
    it "will not create a new orderitem if a required field is missing" do
      orderitem_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: nil }}
      
      expect { post orderitems_path, params: orderitem_hash }.wont_change "Orderitem.count", 1
      
      expect(flash[:error]).must_equal "Error adding product to your cart"
      must_respond_with :redirect
    end      
  end
  
  describe "destroy" do
    it "does not change the database when the orderitem does not exist, and responds with a redirect" do  
      invalid_id = -1
      
      expect{ delete orderitem_path(invalid_id) }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "destroys the orderitem when it exists in the database, and responds with a redirect" do    
      test_orderitem = orderitem
      
      expect { delete orderitem_path(test_orderitem.id) }.must_differ "Orderitem.count", -1
      
      expect(flash[:success]).must_equal "Item removed from your cart"
      must_respond_with :redirect
    end
  end    
end
