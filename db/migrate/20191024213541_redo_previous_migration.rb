class RedoPreviousMigration < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :price, :decimal, precision: 5, scale: 2
  end
end
