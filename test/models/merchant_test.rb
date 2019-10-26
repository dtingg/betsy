require "test_helper"

describe Merchant do
  
  describe "Member Since Method" do
    it "can calculate how long a merchant has been a member" do
      @merchant = merchants(:merchant_two)
      expect((Time.current - @merchant.created_at).to_i).must_equal (@merchant.member_since).to_i
    end
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
  
  it "can build an auth_hash from github" do
  end
  
end
