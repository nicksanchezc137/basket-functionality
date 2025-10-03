# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
ProductCatalogue.destroy_all
DeliveryCharge.destroy_all
Offer.destroy_all

# Create products
products_data = [
  {
    product_name: "Red Widget",
    code: "R01",
    price: 32.95
  },
  {
    product_name: "Green Widget", 
    code: "G01",
    price: 24.95
  },
  {
    product_name: "Blue Widget",
    code: "B01", 
    price: 7.95
  }
]

products = ProductCatalogue.create!(products_data)

puts "Created #{products.count} products"

# Create delivery charges (applying to all products)
delivery_charges_data = [
  {
    lower_limit: 0,
    upper_limit: 50,
    delivery_cost: 4.95
  },
  {
    lower_limit: 50,
    upper_limit: 90,
    delivery_cost: 2.95
  },
  {
    lower_limit: 90,
    upper_limit: 10000000,
    delivery_cost: 0.0
  }
]

# Apply delivery charges to all products
delivery_charges = []
products.each do |product|
  delivery_charges_data.each do |charge_data|
    delivery_charges << product.delivery_charges.create!(charge_data)
  end
end

puts "Created #{delivery_charges.count} delivery charges"

# Create offers
# (Buy One Get One at half price) offer for Red Widget
red_widget = products.find { |p| p.product_name == "Red Widget" }

offer = Offer.create!(
  description: "Buy One Get One at half price",
  product_catalogue: red_widget,
  offer_product_catalogue: red_widget,
  offer_price: -16.48,
  trigger_count: 2
)

puts "Created #{Offer.count} offers"

puts "Seed data created successfully!"
