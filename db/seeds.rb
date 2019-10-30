# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

MERCHANTS_FILE = Rails.root.join('db', "seed_data", 'merchants.csv')
puts "Loading raw merchants data from #{MERCHANTS_FILE}"

merchant_failures = []

CSV.foreach(MERCHANTS_FILE, :headers => true) do |row|
  merchant = Merchant.new
  
  merchant.uid = row["uid"]
  merchant.username = row["username"]
  merchant.email = row["email"]
  
  successful = merchant.save
  
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    # puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

PRODUCTS_FILE = Rails.root.join('db', "seed_data", 'products.csv')
puts "Loading raw products data from #{PRODUCTS_FILE}"

product_failures = []

CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  
  product.name = row["name"]
  product.description = row["description"]
  product.active = row["active"]
  product.stock_qty = row["stock_qty"]
  product.price = row["price"]
  product.merchant_id = row["merchant_id"]
  product.photo_url = row["photo_url"]
  
  successful = product.save
  
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    # puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

REVIEWS_FILE = Rails.root.join('db', "seed_data", 'reviews.csv')
puts "Loading raw reviews data from #{REVIEWS_FILE}"

review_failures = []

CSV.foreach(REVIEWS_FILE, :headers => true) do |row|
  review = Review.new
  
  review.comment = row["comment"]
  review.rating = row["rating"]
  review.date = row["date"]
  review.reviewer = row["reviewer"]
  review.product_id = row["product_id"]
  
  successful = review.save
  
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    # puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"

ORDERS_FILE = Rails.root.join('db', "seed_data", 'orders.csv')
puts "Loading raw orders data from #{ORDERS_FILE}"

order_failures = []

CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new
  
  order.status = row["status"]
  order.name = row["name"]
  order.address = row["address"]
  order.city = row["city"]
  order.state = row["state"]
  order.zipcode = row["zipcode"]
  order.email = row["email"]
  order.cc_num = row["cc_num"]
  order.cc_exp = row["cc_exp"]
  order.cc_cvv = row["cc_cvv"]
  order.order_date = row["order_date"]
  
  successful = order.save
  
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    # puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

ORDERITEMS_FILE = Rails.root.join('db', "seed_data", 'orderitems.csv')
puts "Loading raw orderitems data from #{ORDERITEMS_FILE}"

orderitem_failures = []

CSV.foreach(ORDERITEMS_FILE, :headers => true) do |row|
  orderitem = Orderitem.new
  
  orderitem.quantity = row["quantity"]
  orderitem.order_id = row["order_id"]
  orderitem.product_id = row["product_id"]
  orderitem.complete = row["complete"]
  
  successful = orderitem.save
  
  if !successful
    orderitem_failures << orderitem
    puts "Failed to save orderitem: #{orderitem.inspect}"
  else
    # puts "Created orderitem: #{orderitem.inspect}"
  end
end

puts "Added #{Orderitem.count} orderitem records"
puts "#{orderitem_failures.length} orderitems failed to save"

CATEGORIES_FILE = Rails.root.join('db', "seed_data", 'categories.csv')
puts "Loading raw categories data from #{CATEGORIES_FILE}"

category_failures = []

CSV.foreach(CATEGORIES_FILE, :headers => true) do |row|
  category = Category.new
  
  category.name = row["name"]
  
  successful = category.save
  
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    # puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

CATEGORIESPRODUCTS_FILE = Rails.root.join('db', "seed_data", 'categoriesproducts.csv')
puts "Loading raw categoriesproducts data from #{CATEGORIESPRODUCTS_FILE}"

categoryproduct_failures = []

CSV.foreach(CATEGORIESPRODUCTS_FILE, :headers => true) do |row|
  product = Product.find_by(id: row["product_id"])
  category = Category.find_by(id: row["category_id"])
  
  product.category_ids = product.category_ids << category.id
  
  successful = product.save
  
  if !successful
    categoryproduct_failures << product
    puts "Failed to add a category to product: #{product.inspect}"
  else
    # puts "Added a category to product: #{product.inspect}"
  end
end

puts "#{categoryproduct_failures.length} categoriesproducts failed to save"
