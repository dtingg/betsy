require "test_helper"

describe Orderitem do
  let (:merchant) { Merchant.create(username: "Bob", email: "bob@aol.com", uid: "12347") }
  let (:product) { Product.create(merchant_id: merchant.id, name: "Oatmeal soap", price: 5.55) }
  let (:order) { Order.create(status: "pending") }
  let (:orderitem) { Orderitem.create(order_id: order.id, product_id: product.id, quantity: 3) }
  
  describe "initialize" do
    it "can be instantiated" do
      
      expect(orderitem.valid?).must_equal true
    end
    
    it "will have the required fields" do
      orderitem.save
      
      [:order_id, :product_id, :quantity, :complete].each do |field|
        expect(orderitem).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    it "can have an order" do
      orderitem.save
      
      expect(orderitem.order).must_be_instance_of Order      
    end
    
    it "can have a product" do
      orderitem.save
      
      expect(orderitem.product).must_be_instance_of Product     
    end
  end
  
  describe "validations" do
    it "must have an order_id" do
      orderitem.order_id = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :order_id
      expect(orderitem.errors.messages[:order_id]).must_equal ["can't be blank"]
    end
    
    it "must have a product_id" do
      orderitem.product_id = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product_id
      expect(orderitem.errors.messages[:product_id]).must_equal ["can't be blank"]
    end

    it "must have a valid product_id" do
      orderitem.product_id = -1
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product
      expect(orderitem.errors.messages[:product]).must_equal ["must exist"]
    end
    
    it "must have a quantity" do
      orderitem.quantity = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end
    
    it "must have a quantity greater than 0" do
      orderitem.quantity = 0
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end
    
    it "has a default for complete as false" do
      orderitem.save
      
      expect(orderitem.valid?).must_equal true
      expect(orderitem.complete).must_equal false
    end
  end
  
  describe "increase quantity method" do
    it "will increase the orderitem's quantity and reduce the product's inventory" do
      previous_orderitem_quantity = orderitem.quantity
      previous_product_quantity = product.stock_qty
      
      orderitem.increase_qty(3)
      
      updated_orderitem = Orderitem.find_by(id: orderitem.id)
      updated_product = Product.find_by(id: product.id)
      expect(updated_orderitem.quantity).must_equal (previous_orderitem_quantity + 3)
      expect(updated_product.stock_qty).must_equal (previous_product_quantity - 3)      
    end
  end

  describe "check quantity method" do
    it "will return true when requested quantity is less than or equal to amount in stock and product is active" do
      product_quantity = product.stock_qty

      status = orderitem.check_qty(product_quantity)

      expect(status).must_equal true
    end

    it "will return false when requested quantity is greater than amount in stock" do
      product_quantity = product.stock_qty

      status = orderitem.check_qty(product_quantity + 1)

      expect(status).must_equal false
    end

    it "will return false when product requested is marked inactive" do
      product.update(active: false)
      product_quantity = product.stock_qty

      status = orderitem.check_qty(product_quantity)

      expect(status).must_equal false
    end
  end
  
  describe "remove from cart method" do
    it "will return the orderitem's quantity to the product's inventory and will be destroyed" do
      orderitem.save
      previous_product_quantity = product.stock_qty
      
      expect { orderitem.remove_from_cart }.must_change "Orderitem.count", -1
      
      updated_product = Product.find_by(id: product.id)
      
      expect(updated_product.stock_qty).must_equal (previous_product_quantity + orderitem.quantity)
    end
  end
  
  describe "total method" do
    it "correctly returns the total of the orderitem" do
      total = orderitem.total
      
      expect(total).must_equal (orderitem.quantity * orderitem.product.price)
    end
  end
  
  describe "change orderitem status" do
    it "will correctly change orderitem status" do
      orderitem.complete = false
      orderitem.save
      orderitem.mark_complete
      expect(orderitem.complete).must_equal true
    end
  end
  
  describe "self.exists method" do
    it "will return an orderitem object if it already exists" do
      orderitem.save
      result = Orderitem.exists?(order.id, product.id)
      
      expect(result.id).must_equal orderitem.id
      expect(result.order_id).must_equal orderitem.order_id
      expect(result.product_id).must_equal orderitem.product_id
      expect(result.complete).must_equal orderitem.complete  
    end
    
    it "will return false if the orderitem does not already exist" do
      orderitem.save      
      result = Orderitem.exists?(-1, -1)
      
      expect(result).must_equal false
    end
  end
end
