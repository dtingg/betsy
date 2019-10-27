require "test_helper"

describe CategoriesController do
  describe "authenticated" do
    # perform login
    describe "new" do
      it "should get the new category path" do
  
        get new_category_path
        must_respond_with :success
      end
    end

    describe "create" do
      it "should create a new category" do
        
        new_category_params = {category: {name: "A Wonderful New Category"}}
  
        expect {
          post categories_path, params: new_category_params 
        }.must_change "Category.count", 1
  
        new_category = Category.find_by(name: new_category_params[:category][:name])
        expect(new_category.name).must_equal new_category_params[:category][:name]
      end

    it "should not create a new category when name is set to nil" do
      new_category_params = {category: {name: nil}}

      expect {
        post categories_path, params: new_category_params 
      }.wont_change "Category.count"
    end

    it "should not create a new category when name is an empty string" do
      # empty string
      new_category_params = {category: {name: ""}}

      expect {
        post categories_path, params: new_category_params 
      }.wont_change "Category.count"

      # whitespace
      new_category_params = {category: {name: "   "}}

      expect {
        post categories_path, params: new_category_params 
      }.wont_change "Category.count"
    end
  end
end

  

  describe "guest user" do 
    describe "index" do
      it "should respond with success" do
      get categories_path
      must_respond_with :success
      end

      it "should not break if there are no categories" do
        Category.destroy_all
        get categories_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "should respond with success when asked to show a particular category" do
        bubbly_category = categories(:bubbly)

        get categories_path(bubbly_category.id)
        must_respond_with :success
      end

      it "should respond with redirect when given an invalid category" do
        get category_path(-1)
        must_respond_with :redirect
      end
    end
  end
end
