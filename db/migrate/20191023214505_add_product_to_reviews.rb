class AddProductToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :review, foreign_key: true
  end
end
