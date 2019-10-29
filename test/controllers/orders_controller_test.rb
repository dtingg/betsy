require "test_helper"

describe OrdersController do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com", uid: "12345") }
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
    
    # it "responds with redirect when getting the edit page for a completed order" do
    #   order.save
    
    #   get edit_order_path(order.id)
    
    #   must_respond_with :redirect
    # end
  end
  
  
  
  
  
  
  describe "update" do
    # it "can update a pending order with valid information successfully, flashes a message, redirects, and clears the cart" do      
    #   pending_order.save
    
    #   changes_hash = { order: { status: "paid", name: "Wilma Flintstone", email: "wilma@yahoo.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new } }  
    
    #   patch order_path(pending_order.id), params: changes_hash
    
    #   updated_order = Order.find_by(id: pending_order.id)
    
    #   expect(updated_order.status).must_equal changes_hash[:order][:status]
    #   expect(updated_order.name).must_equal changes_hash[:order][:name]
    #   expect(updated_order.email).must_equal changes_hash[:order][:email]
    #   expect(updated_order.address).must_equal changes_hash[:order][:address]
    #   expect(updated_order.city).must_equal changes_hash[:order][:city]
    #   expect(updated_order.state).must_equal changes_hash[:order][:state]
    #   expect(updated_order.zipcode).must_equal changes_hash[:order][:zipcode]
    #   expect(updated_order.cc_num).must_equal changes_hash[:order][:cc_num]
    #   expect(updated_order.cc_exp).must_equal changes_hash[:order][:cc_exp]
    #   expect(updated_order.cc_cvv).must_equal changes_hash[:order][:cc_cvv]
    #   expect(updated_order.order_date).must_be_instance_of ActiveSupport::TimeWithZone
    
    #   expect(flash[:success]).must_equal "Thank you for your order!"   
    #   must_respond_with :redirect
    #   assert_nil(session[:cart_id])
    # end    
    
    it "does not update an order if given an invalid id and responds with a redirect" do
      changes_hash = { order: { status: "paid", name: "Wilma Flintstone", email: "wilma@yahoo.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new } }  
      invalid_id = -1
      
      patch order_path(invalid_id), params: changes_hash
      
      must_respond_with :redirect
    end
    
    it "does not update an order if the form data violates Order validations" do
      old_order = order
      changes_hash = { order: { name: nil } }  
      
      patch order_path(old_order.id), params: changes_hash
      
      updated_order = Order.find_by(id: old_order.id)
      expect(updated_order.name).must_equal old_order.name
    end
  end
end
