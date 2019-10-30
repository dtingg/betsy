require "test_helper"

describe Category do
  describe "initialize" do
    before do
      @new_category = Category.new(name: "The Best Category")
    end

    it "can be instantiated" do
      expect(@new_category.valid?).must_equal true
    end

    it "will have the required fields" do
      expect(@new_category).must_respond_to :name
    end
  end

  describe "relationships" do
    let(:bubbly) { categories(:bubbly) }
    let(:goat) { categories(:goat) }
    let(:organic) { categories(:organic) }

    describe "products" do
      it "can have zero products" do
        random_category = Category.new(name: "random")

        expect(random_category.valid?).must_equal true
      end

      it "can have one or more products" do
        expect(bubbly.products.count).must_equal bubbly.products.count

        expect(bubbly.products.first).must_be_instance_of Product
        expect(organic.products.count).must_equal 2
        expect(goat.products).must_be_empty
        expect(goat.products.length).must_equal 0
      end

      it "can set a product through 'product'" do
        random_category = Category.new(name: "random")

        random_category.products.push(products(:onion))

        expect(random_category.products.last.id).must_equal products(:onion).id
      end
    end
    
    it "should remove category relation when a product is deleted" do
      before_count = bubbly.products.count
      potter = products(:potter)
      potter.destroy
      expect(bubbly.products.count).must_equal (before_count - 1) 
    end
  end

  describe "validations" do
  let(:bubbly) { categories(:bubbly) }

    describe "name" do
      it "should have a name that is a string" do
        expect(bubbly.name).must_be_instance_of String
        expect(bubbly.name).must_equal categories(:bubbly).name
      end

      it "should not allow an empty string for name" do
        category = categories(:bubbly)
        category.name = ""

        expect(category.valid?).must_equal false
        expect(category.errors.messages).must_include :name
        expect(category.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "should validate the presence of name" do
        category = categories(:bubbly)
        category.name = nil
  
        expect(category.valid?).must_equal false
        expect(category.errors.messages).must_include :name
        expect(category.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "should not allow a string with only whitespace for name" do
        category = categories(:bubbly)
        category.name = "     "
  
        expect(category.valid?).must_equal false
        expect(category.errors.messages).must_include :name
        expect(category.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "is not valid if name is not unique" do
        duplicate_category = Category.new(name: "bubbly")

        expect(duplicate_category.valid?).must_equal false
        expect(duplicate_category.errors.messages).must_include :name
        expect(duplicate_category.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end   
  end
end
