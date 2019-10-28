require "test_helper"

describe Order do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com") }
  let (:oatmeal_soap) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.50, photo_url: "") }
  let (:lemon_soap) { Product.create(merchant_id: merchant.id, name: "Lemon soap", price: 1.50, photo_url: "") }
  let (:order) { Order.create(status: "complete", name: "Fred Flintstone", email: "fred@aol.com", address: "123 Bedrock Lane", city: "Bedrock", state: "CA", zipcode: "10025", cc_num: "1234567890123", cc_exp: "1219", cc_cvv: "123", order_date: Time.new ) }  
  let (:new_order) { Order.create(status: "pending")}
  let (:orderitem_one) { Orderitem.create(order_id: order.id, product_id: oatmeal_soap.id, quantity: 1) }
  let (:orderitem_two) { Orderitem.create(order_id: order.id, product_id: lemon_soap.id, quantity: 2) }
  
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
