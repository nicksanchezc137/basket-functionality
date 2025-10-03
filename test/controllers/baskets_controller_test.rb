require 'test_helper'

class BasketsControllerTest < ActionDispatch::IntegrationTest
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

    # Create Buy one get one at half price offer for Red Widget
    @red_widget_offer = Offer.create!(
      description: "Buy One Get One at half price",
      product_catalogue: @red_widget,
      offer_product_catalogue: @red_widget,
      offer_price: -16.48,
      trigger_count: 2
    )
  end

  test "should get basket index" do
    get baskets_url
    assert_response :success
  end

  test "should add B01 and G01 to basket and calculate correct total" do
    # Add B01 (Blue Widget)
    post add_baskets_path, params: { product_code: "B01" }
    assert_redirected_to baskets_path
    
    # Add G01 (Green Widget)
    post add_baskets_path, params: { product_code: "G01" }
    assert_redirected_to baskets_path
    
    # Check basket totals
    basket = Basket.first
    assert_not_nil basket
    
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 32.90, subtotal, "Subtotal should be $32.90"
    assert_equal 4.95, delivery_charge, "Delivery charge should be $4.95"
    assert_equal 37.85, total, "Total should be $37.85"
  end

  test "should add R01, R01 and apply Buy one get one at half price offer" do
    # Add first R01 (Red Widget)
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Add second R01 (Red Widget) - should trigger Buy one get one at half price
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Check basket totals
    basket = Basket.first
    assert_not_nil basket
    
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 49.42, subtotal, "Subtotal should be $49.42 (2×$32.95 + $(-16.48))"
    assert_equal 4.95, delivery_charge, "Delivery charge should be $4.95"
    assert_equal 54.37, total, "Total should be $54.37"
    
    # Verify Buy one get one at half price offer was applied
    offer_line_items = basket.basket_line_items.where(offer: @red_widget_offer)
    assert_equal 1, offer_line_items.count, "Buy one get one at half price offer should be applied"
  end

  test "should add R01 and G01 to basket" do
    # Add R01 (Red Widget)
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Add G01 (Green Widget)
    post add_baskets_path, params: { product_code: "G01" }
    assert_redirected_to baskets_path
    
    # Check basket totals
    basket = Basket.first
    assert_not_nil basket
    
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    assert_equal 57.90, subtotal, "Subtotal should be $57.90"
    assert_equal 2.95, delivery_charge, "Delivery charge should be $2.95"
    assert_equal 60.85, total, "Total should be $60.85"
  end

  test "should add B01, B01, R01, R01, R01 and apply Buy one get one at half price offer" do
    # Add B01 (Blue Widget)
    post add_baskets_path, params: { product_code: "B01" }
    assert_redirected_to baskets_path
    
    # Add B01 (Blue Widget)
    post add_baskets_path, params: { product_code: "B01" }
    assert_redirected_to baskets_path
    
    # Add first R01 (Red Widget)
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Add second R01 (Red Widget) - should trigger Buy one get one at half price
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Add third R01 (Red Widget)
    post add_baskets_path, params: { product_code: "R01" }
    assert_redirected_to baskets_path
    
    # Check basket totals
    basket = Basket.first
    assert_not_nil basket
    
    subtotal = basket.total_price
    delivery_charge = calculate_delivery_charge(subtotal)
    total = subtotal + delivery_charge
    
    expected_subtotal = (7.95 * 2) + (32.95 * 3) + (-16.48) # 15.90 + 98.85 - 16.48 = 98.27
    assert_in_delta expected_subtotal, subtotal, 0.01, "Subtotal should be $98.27"
    assert_equal 0.0, delivery_charge, "Delivery charge should be $0.00 (free delivery over $90)"
    assert_equal 98.27, total, "Total should be $98.27"
    
    # Verify Buy one get one at half price offer was applied
    offer_line_items = basket.basket_line_items.where(offer: @red_widget_offer)
    assert_equal 1, offer_line_items.count, "Buy one get one at half price offer should be applied"
  end

  test "should remove offer when product count drops below trigger" do
    # Add two R01 items to trigger Buy one get one at half price
    post add_baskets_path, params: { product_code: "R01" }
    post add_baskets_path, params: { product_code: "R01" }
    
    basket = Basket.first
    assert_equal 1, basket.basket_line_items.where(offer: @red_widget_offer).count, "Buy one get one at half price should be applied"
    
    # Remove one R01 item
    regular_item = basket.basket_line_items.where(offer: nil, product_catalogue: @red_widget).first
    delete basket_line_item_path(regular_item)
    assert_redirected_to baskets_path
    
    # Check that Buy one get one at half price offer was removed
    basket.reload
    assert_equal 0, basket.basket_line_items.where(offer: @red_widget_offer).count, "Buy one get one at half price should be removed"
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
