require "test_helper"

describe OrdersController do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com") }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.55, photo_url: "") }
  let (:order) { Order.create(status: "complete", name: "Fred Flintstone", email: "fred@aol.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new ) }  
  let (:orderitem) { Orderitem.create(order_id: order.id, product_id: product.id, quantity: 3) }
  let (:pending_order) { Order.create(status: "pending", name: "Fred Flintstone", email: "fred@aol.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new ) }  
  let (:new_order) { Order.create(status: "pending")}
  
  describe "show" do
    it "responds with success when showing a valid, completed order" do
      get order_path(order.id)
      
      must_respond_with :success
    end
    
    it "redirects if given invalid order id" do
      invalid_id = -1
      
      get order_path(invalid_id)
      
      must_respond_with :redirect
    end
    
    it "redirects to cart if given a pending order id" do
      get order_path(pending_order.id)
      
      must_respond_with :redirect
    end
    
    describe "edit" do
      it "responds with success when getting the edit page for a valid, pending order" do
        get edit_order_path(pending_order.id)
        
        must_respond_with :success
      end
      
      it "responds with redirect when getting the edit page for a non-existing order" do
        invalid_id = -1
        
        get edit_order_path(invalid_id)
        
        must_respond_with :redirect
      end
      
      it "responds with redirect when getting the edit page for an order that is not pending" do
        order.save
        
        get edit_order_path(order.id)
        
        must_respond_with :redirect
      end
    end
  end
end
