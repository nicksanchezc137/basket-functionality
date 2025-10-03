class BasketLineItem < ApplicationRecord
  # Associations
  belongs_to :basket
  belongs_to :product_catalogue
  belongs_to :offer, optional: true

  # Validations
  validates :price, presence: true, numericality: { greater_than: 0 }, unless: :offer?
  validates :price, presence: true, numericality: true, if: :offer?
  validate :offer_matches_product

  # Methods
  def offer?
    offer.present?
  end

  private

  def offer_matches_product
    return unless offer_id && product_catalogue_id
    
    # Ensure the offer is valid for this product
    unless offer.product_catalogue_id == product_catalogue_id
      errors.add(:offer, "must be valid for the selected product")
    end
  end
end
