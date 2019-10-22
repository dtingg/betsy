class AddRelationshipsToReview < ActiveRecord::Migration[5.2]
  def change
    def change
      add_reference :reviews, :product, foreign_key: true
    end
  end
end
