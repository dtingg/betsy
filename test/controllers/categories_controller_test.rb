require "test_helper"

describe CategoriesController do
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

  describe "create" do

  end
end
