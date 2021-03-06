require "test_helper"

describe MerchantsController do
  describe "guest user (not authenticated)" do
    describe "index" do
      it "should display all merchants" do
        get merchants_path 
        
        must_respond_with :success
      end
      
      it "should not break if there are no merchants" do 
        Merchant.destroy_all
        
        get merchants_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "should respond with success when given a valid merchant" do
        merchant_one = merchants(:merchant_one)
        
        get merchant_path(merchant_one.id)
        must_respond_with :success
      end
      
      it "should respond with redirect with an invalid merchant" do 
        get merchant_path(-9)
        
        must_respond_with :redirect
        must_redirect_to merchants_path
      end
    end
    
    describe "dashboard" do
      it "redirects to root path when merchant not logged in" do
        get dashboard_path
        
        
        expect(flash[:failure]).must_equal "A problem occurred: You are not authorized to perform this action"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end
  
  describe "authenticated user" do
    before do
      perform_login(merchants(:merchant_two))
    end
    
    describe "dashboard" do
      it "shows dashboard for user that is logged in" do
        get dashboard_path
        
        must_respond_with :success
      end
    end
    
    describe "logout" do
      it "successfully logs out current user" do
        expect(session[:user_id].nil?).must_equal false
        
        post logout_path
        
        assert_nil(session[:user_id])
        expect(flash[:success]).must_equal "Successfully logged out"
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end
  
  describe "auth_callback" do
    it "logs in an existing user and redirects" do
      start_count = Merchant.count
      
      merchant = merchants(:merchant_one)
      
      perform_login(merchant)
      
      must_respond_with :redirect
      must_redirect_to dashboard_path
      
      expect(Merchant.find_by(id: session[:user_id])).must_equal merchant
      _(Merchant.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects" do
      start_count = Merchant.count
      
      new_merchant = Merchant.new(username:"randomkathy", email: "whatev@git.com", uid: 473837)
      
      expect{ 
        perform_login(new_merchant) 
      }.must_differ "Merchant.count", 1
      
      expect(Merchant.find_by(id: session[:user_id])).must_equal Merchant.all.last
      
      must_respond_with :redirect
      must_redirect_to dashboard_path
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = Merchant.count
      
      new_merchant = Merchant.new(username:"randomkathy", email: "whatev@git.com", uid: nil)
      
      expect{ 
        perform_login(new_merchant)
      }.wont_change "Merchant.count"
      
      must_respond_with :redirect
      must_redirect_to merchants_path
    end
  end
end
