class DeliveryCharge < ApplicationRecord
  # Associations
  belongs_to :product_catalogue

  # Validations
  validates :lower_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :upper_limit, presence: true, numericality: { greater_than: :lower_limit }
  validates :delivery_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Custom validation to ensure upper_limit is greater than lower_limit
  validate :upper_limit_greater_than_lower_limit

  private

  def upper_limit_greater_than_lower_limit
    return unless lower_limit && upper_limit
    
    if upper_limit <= lower_limit
      errors.add(:upper_limit, "must be greater than lower limit")
    end
  end
end
