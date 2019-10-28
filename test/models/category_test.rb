require "test_helper"

describe Category do
  describe "relations" do
    it "should have a list of products" do
    bubbly = categories(:bubbly)
    expect(bubbly.products.count).must_equal 2
    end

    
  end

  describe "validations" do
  let(:bubbly) { categories(:bubbly) }
    it "should have a name that is a string" do
      expect(bubbly.name).must_be_instance_of String
      expect(bubbly.name).must_equal categories(:bubbly).name
    end

    # it "should validate the presence of name" do
    #   bubbly.name = ""
    #   expect
    # end

  end
end
