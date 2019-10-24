class AddCompleteColumnToOrderitems < ActiveRecord::Migration[5.2]
  def change
    add_column :orderitems, :complete, :boolean, default: false
  end
end
