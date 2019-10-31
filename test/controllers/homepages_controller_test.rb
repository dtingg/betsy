require "test_helper"

describe HomepagesController do
  describe "index" do
    it "responds with success when there are products saved" do
      get root_path

      must_respond_with :success
    end

    it "responds with success when there are no products saved" do
      Product.destroy_all

      get root_path

      must_respond_with :success
    end
  end

  describe "search" do
    it "shows error message if blank search" do
  
      new_search = {
        Parameters: 
        { "search"=>""}
      }

      get search_path, params: new_search
      
      expect(flash[:failure]).wont_be_nil
      must_respond_with :redirect
    end

    it "shows search results when not blank field" do
      new_search = {
        Parameters: 
        { "search"=>"a"}
      }

      get search_path, params: new_search

      must_respond_with :redirect
    end

  end
end
