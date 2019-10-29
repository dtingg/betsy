require "test_helper"

describe Review do
  let (:new_review) { reviews(:review_one) }

  describe "initialize" do
    it "can be instantiated" do
      expect(new_review.valid?).must_equal true
      expect(new_review).must_be_instance_of Review     
    end
    
    it "will have the required fields" do
      new_review.save
      
      [:comment, :product_id, :rating].each do |field|
        expect(new_review).must_respond_to field
      end
    end
  end

  describe "validations" do  
    it "must have a comment" do
      new_review.comment = nil
      new_review.save
      
      # Assert
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :comment
      expect(new_review.errors.messages[:comment]).must_equal ["can't be blank"]
    end
  
    it "must have a product_id" do
      new_review.product_id = nil
      new_review.save
      
      # Assert
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :product_id
      expect(new_review.errors.messages[:product_id]).must_equal ["can't be blank"]
    end

    it "must have a rating" do
      new_review.rating = nil
      new_review.save
      
      # Assert
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
    end
  end
  
  describe "relationships" do
    it "belongs to a product" do
      new_review.save

    # Assert
    expect(new_review.product).must_equal products(:potter)
    end
  end
end
