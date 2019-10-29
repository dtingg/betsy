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
      it "should respond with error when guest user tries to access dashboard" do
        merchant_one = merchants(:merchant_one)

        get dashboard_path(merchant_one)

        expect(flash[:failure]).must_equal "A problem occurred: You are not authorized to perform this action"

        must_respond_with :redirect
        must_redirect_to merchants_path
      end
    end

    describe "delete" do
      it "should respond with error when guest user tries to delete merchant" do
        merchant_one = merchants(:merchant_one)

        expect {
          delete merchant_path(merchant_one)
        }.wont_change "Merchant.count"

        expect(flash[:failure]).must_equal "A problem occurred: You are not authorized to perform this action"

        must_respond_with :redirect
        must_redirect_to merchants_path
      end
    end
  end

  describe "authenticated user" do
    describe "dashboard" do
      it "should show dashboard for user that is logged in" do
        
      end

      it "should not show dashboard for another merchant account" do

      end
    end

    describe "delete" do
      it "should delete valid user for user that is logged in" do
      end

      it "cannot delete another merchant account" do
      end
    end

    describe "logout" do
    end
  end

  describe "auth_callback" do
    it "logs in an existing user and redirects" do
      start_count = Merchant.count

      merchant = merchants(:merchant_one)

      perform_login(merchant)

      must_respond_with :redirect
      must_redirect_to merchants_path

      _(Merchant.count).must_equal start_count
    end

    it "creates an account for a new user and redirects" do
      start_count = Merchant.count

      new_merchant = Merchant.new(username:"randomkathy", email: "whatev@git.com", uid: 473837)

      expect{ 
        perform_login(new_merchant) 
      }.must_differ "Merchant.count", 1

      must_respond_with :redirect
      must_redirect_to merchants_path
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
