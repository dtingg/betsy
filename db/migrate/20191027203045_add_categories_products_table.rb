class AddCategoriesProductsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_products do |t|
      t.belongs_to :category
      t.belongs_to :product
    end
  end
end
