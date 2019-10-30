require "test_helper"

describe Review do
  let (:new_review) { reviews(:review_one) }

  describe "initialize" do
    before do
      @valid_review = Review.new(reviewer: "random", comment: "nothing", rating: 5, product_id: products(:potter).id)
    end

    it "can be instantiated" do
      expect(@valid_review.valid?).must_equal true
      expect(@valid_review).must_be_instance_of Review     
    end
    
    it "will have the required fields" do
      @valid_review.save
      
      [:comment, :product_id, :rating, :reviewer].each do |field|
        expect(@valid_review).must_respond_to field
      end
    end
  end

  describe "validations" do  
    describe "reviewer" do
      it "must have a reviewer" do
        new_review.reviewer = nil
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :reviewer
        expect(new_review.errors.messages[:reviewer]).must_equal ["can't be blank"]
      end
    end

    describe "comment" do
      it "must have a comment" do
        new_review.comment = nil
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :comment
        expect(new_review.errors.messages[:comment]).must_equal ["can't be blank"]
      end
    end
  
    describe "product_id" do
      it "must have a product_id" do
        new_review.product_id = nil
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :product_id
        expect(new_review.errors.messages[:product_id]).must_equal ["can't be blank"]
      end
    end

    describe 'rating' do
      it "must have a rating" do
        new_review.rating = nil
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :rating
        expect(new_review.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
      end

      it "rating must be integer" do
        new_review.rating = "five"
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :rating
        expect(new_review.errors.messages[:rating]).must_equal ["is not a number"]
      end

      it "must have a rating more than 0" do
        new_review.rating = 0
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :rating
        expect(new_review.errors.messages[:rating]).must_equal ["must be greater than 0"]
      end

      it "must have a rating less than 6" do
        new_review.rating = 6
        new_review.save
        
        expect(new_review.valid?).must_equal false
        expect(new_review.errors.messages).must_include :rating
        expect(new_review.errors.messages[:rating]).must_equal ["must be less than 6"]
      end
    end
  end
  
  describe "relationships" do
    it "has a product" do
      review = reviews(:review_two)
      
      expect(review.product).must_be_instance_of Product      
    end

    it "can set a product through 'product'" do
      review = Review.new(reviewer: "random", comment: "nothing", rating: 5)

      review.product = products(:cucumber)

      expect(review.product_id).must_equal products(:cucumber).id
      expect(review.valid?).must_equal true
    end

    it "can set a product through 'product_id'" do
      review = Review.new(reviewer: "random", comment: "nothing", rating: 5)

      review.product_id = products(:rose).id

      expect(review.product).must_equal products(:rose)
      expect(review.valid?).must_equal true
    end
  end
end
