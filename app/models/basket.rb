class Basket < ApplicationRecord
  # Associations
  has_many :basket_line_items, dependent: :destroy
  has_many :product_catalogues, through: :basket_line_items

  # Methods
  def total_price
    basket_line_items.sum(&:price)
  end

  def line_items_count
    basket_line_items.count
  end
end
