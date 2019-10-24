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
