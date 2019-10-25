require "faker"
require "date"
require "csv"

# run using the command:
# $ ruby db/generate_seeds.rb
# recreate the db with:
# $ rails db:reset

# Products (50)
CSV.open("db/seed_data/products.csv", "w", :write_headers => true, :headers => ["name", "description", "active", "stock_qty", "price", "merchant_id", "photo_url"]) do |csv|
  50.times do
    name = Faker::Food.unique.dish
    description = Faker::Food.description
    active = Faker::Boolean.boolean
    stock_qty = rand(0..20)
    price = Faker::Commerce.price
    merchant_id = rand(1..25)
    photo_url = Faker::Internet.url
    
    csv << [name, description, active, stock_qty, price, merchant_id, photo_url]
  end
end

# Merchants (25)
CSV.open("db/seed_data/merchants.csv", "w", :write_headers => true, :headers => ["uid", "username", "email"]) do |csv|
  25.times do
    uid = Faker::Number.number(digits: 5)
    username = Faker::Internet.username
    email = Faker::Internet.email
    
    csv << [uid, username, email]
  end
end

# Reviews (50)
CSV.open("db/seed_data/reviews.csv", "w", :write_headers => true, :headers => ["comment", "rating", "date", "reviewer", "product_id"]) do |csv|
  50.times do
    comment = Faker::Restaurant.review
    rating = rand(1..5)
    date = rand(Date.today - 500..Date.today)
    reviewer = Faker::Name.name
    product_id = rand(1..50)
    
    csv << [comment, rating, date, reviewer, product_id]
  end
end
