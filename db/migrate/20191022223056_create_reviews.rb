class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :comment
      t.integer :rating
      t.datetime :date
      t.string :reviewer

      t.timestamps
    end
  end
end
