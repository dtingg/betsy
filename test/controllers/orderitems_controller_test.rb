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
      orderitem_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 3 } }
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
    
    it "can update the quantity of an existing orderitem accurately, updates product quantity, and redirects" do
      orderitem.save
      previous_orderitem_quantity = orderitem.quantity
      
      previous_product_quantity = product.stock_qty
      
      update_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 3 }}
      
      expect { post orderitems_path, params: update_hash }.wont_change "Orderitem.count", 1
      
      new_orderitem = Orderitem.find_by(id: orderitem.id)
      new_product = Product.find_by(id: product.id)
      
      expect(new_orderitem.quantity).must_equal (previous_orderitem_quantity + update_hash[:orderitem][:quantity])
      expect(new_product.stock_qty).must_equal (previous_product_quantity - update_hash[:orderitem][:quantity])
      
      expect(flash[:success]).must_equal "Item quantity updated"
      must_respond_with :redirect  
    end
    
    it "will not create a new orderitem if a required field is missing" do
      orderitem_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: nil }}
      
      expect { post orderitems_path, params: orderitem_hash }.wont_change "Orderitem.count", 1
      
      expect(flash[:error]).must_equal "Error adding product to your cart"
      must_respond_with :redirect
    end      
  end
  
  describe "edit" do
    it "redirects if it doesn't have a valid orderitem" do
      invalid_id = -1
      
      get edit_orderitem_path(invalid_id)
      
      must_respond_with :redirect
      
    end
  end
  
  describe "update" do
    it "does not update any orderitem if given an invalid id, and responds with a redirect" do
      orderitem_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 3 } }
      
      invalid_id = -1
      
      expect { patch orderitem_path(invalid_id), params: orderitem_hash }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "can update an existing orderitem with a larger quantity successfully, and redirects" do
      orderitem.save
      changes_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 5}, old_quantity: 3 }
      
      expect { patch orderitem_path(orderitem.id), params: changes_hash }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: orderitem.id)
      
      expect(updated_orderitem.order_id).must_equal changes_hash[:orderitem][:order_id]
      expect(updated_orderitem.product_id).must_equal changes_hash[:orderitem][:product_id]
      expect(updated_orderitem.quantity).must_equal changes_hash[:orderitem][:quantity]
      expect(flash[:success]).must_equal "Product quantity updated"
      must_respond_with :redirect
    end
    
    it "can update an existing orderitem with a lower quantity successfully, and redirects" do
      orderitem.save
      changes_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: 1}, old_quantity: 3 }
      
      expect { patch orderitem_path(orderitem.id), params: changes_hash }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: orderitem.id)
      
      expect(updated_orderitem.order_id).must_equal changes_hash[:orderitem][:order_id]
      expect(updated_orderitem.product_id).must_equal changes_hash[:orderitem][:product_id]
      expect(updated_orderitem.quantity).must_equal changes_hash[:orderitem][:quantity]
      expect(flash[:success]).must_equal "Product quantity updated"
      must_respond_with :redirect
    end
    
    it "won't change an existing orderitem if it is missing data and redirects" do
      orderitem.save
      changes_hash = { orderitem: { order_id: order.id, product_id: product.id, quantity: nil } }
      
      expect { patch orderitem_path(orderitem.id), params: changes_hash }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: orderitem.id)
      
      expect(updated_orderitem.order_id).must_equal orderitem.order_id
      expect(updated_orderitem.product_id).must_equal orderitem.product_id
      expect(updated_orderitem.quantity).must_equal orderitem.quantity
      expect(flash[:error]).must_equal "Unable to update product quantity"
      must_respond_with :redirect
    end    
  end
  
  describe "destroy" do
    it "does not change the database when the orderitem does not exist, and responds with a redirect" do  
      invalid_id = -1
      
      expect{ delete orderitem_path(invalid_id) }.wont_change "Orderitem.count"
      expect(flash[:error]).must_equal "Unable to remove item from cart"
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
