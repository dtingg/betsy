class AddCcColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :email, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :cc_exp, :string
    add_column :orders, :cc_cvv, :string
    remove_column :orders, :order_date
    add_column :orders, :order_date, :datetime
  end
end
