require 'test_helper'

class BasketTest < ActiveSupport::TestCase
  def setup
    # Clear existing data
    Basket.destroy_all
    BasketLineItem.destroy_all
    ProductCatalogue.destroy_all
    Offer.destroy_all
    DeliveryCharge.destroy_all

    # Create products from seeds data
    @red_widget = ProductCatalogue.create!(
      product_name: "Red Widget",
      code: "R01",
      price: 32.95
    )

    @green_widget = ProductCatalogue.create!(
      product_name: "Green Widget",
      code: "G01", 
      price: 24.95
    )

    @blue_widget = ProductCatalogue.create!(
      product_name: "Blue Widget",
      code: "B01",
      price: 7.95
    )

    # Create delivery charges
    delivery_charges_data = [
      { lower_limit: 0, upper_limit: 50, delivery_cost: 4.95 },
      { lower_limit: 50, upper_limit: 90, delivery_cost: 2.95 },
      { lower_limit: 90, upper_limit: 10000000, delivery_cost: 0.0 }
    ]

    [@red_widget, @green_widget, @blue_widget].each do |product|
      delivery_charges_data.each do |charge_data|
        product.delivery_charges.create!(charge_data)
      end
    end

    # Create BOGOF offer for Red Widget
    @bogof_offer = Offer.create!(
      description: "Buy One Get One at half price",
      product_catalogue: @red_widget,
      offer_product_catalogue: @red_widget,
      offer_price: -16.48,
      trigger_count: 2
    )
  end

  test "B01, G01 should total $37.85" do
    basket = Basket.create!
    
    # Add B01 (Blue Widget) - $7.95
    basket.basket_line_items.create!(
      product_catalogue: @blue_widget,
      price: @blue_widget.price
    )
    
    # Add G01 (Green Widget) - $24.95
    basket.basket_line_items.create!(
      product_catalogue: @green_widget,
      price: @green_widget.price
    )
    
    # Calculate totals
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 32.90, subtotal, "Subtotal should be $32.90"
    assert_equal 4.95, delivery_charge, "Delivery charge should be $4.95"
    assert_equal 37.85, total, "Total should be $37.85"
  end

  test "R01, R01 should total $54.37" do
    basket = Basket.create!
    
    # Add first R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Add second R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Apply BOGOF offer - should add offer line item
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @bogof_offer.offer_price,
      offer: @bogof_offer
    )
    
    # Calculate totals
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 49.42, subtotal, "Subtotal should be $49.42 (2×$32.95 + $(-16.48))"
    assert_equal 4.95, delivery_charge, "Delivery charge should be $4.95"
    assert_equal 54.37, total, "Total should be $54.37"
  end

  test "R01, G01 should total $60.85" do
    basket = Basket.create!
    
    # Add R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Add G01 (Green Widget) - $24.95
    basket.basket_line_items.create!(
      product_catalogue: @green_widget,
      price: @green_widget.price
    )
    
    # Calculate totals
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 57.90, subtotal, "Subtotal should be $57.90"
    assert_equal 2.95, delivery_charge, "Delivery charge should be $2.95"
    assert_equal 60.85, total, "Total should be $60.85"
  end

  test "B01, B01, R01, R01, R01 should total $98.27" do
    basket = Basket.create!
    
    # Add B01 (Blue Widget) - $7.95
    basket.basket_line_items.create!(
      product_catalogue: @blue_widget,
      price: @blue_widget.price
    )
    
    # Add B01 (Blue Widget) - $7.95
    basket.basket_line_items.create!(
      product_catalogue: @blue_widget,
      price: @blue_widget.price
    )
    
    # Add first R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Add second R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Add third R01 (Red Widget) - $32.95
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @red_widget.price
    )
    
    # Apply BOGOF offer for the two R01 items
    basket.basket_line_items.create!(
      product_catalogue: @red_widget,
      price: @bogof_offer.offer_price,
      offer: @bogof_offer
    )
    
    # Calculate totals
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    expected_subtotal = (7.95 * 2) + (32.95 * 3) + (-16.48) # 15.90 + 98.85 - 16.48 = 98.27
    assert_in_delta expected_subtotal, subtotal, 0.01, "Subtotal should be $98.27"
    assert_equal 0.0, delivery_charge, "Delivery charge should be $0.00 (free delivery over $90)"
    assert_equal 98.27, total, "Total should be $98.27"
  end

  private

  def calculate_delivery_charge(total)
    return 0 if total <= 0
    
    delivery_charge = DeliveryCharge.where('lower_limit <= ? AND upper_limit >= ?', total, total).first
    
    if delivery_charge
      delivery_charge.delivery_cost
    else
      DeliveryCharge.where('lower_limit <= ?', total).order(:lower_limit).last&.delivery_cost || 0
    end
  end
end
