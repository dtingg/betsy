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
end
