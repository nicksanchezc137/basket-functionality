class Offer < ApplicationRecord
  # Associations
  belongs_to :product_catalogue
  belongs_to :offer_product_catalogue, class_name: 'ProductCatalogue'
  has_many :baskets, dependent: :destroy

  # Validations
  validates :description, presence: true, length: { maximum: 255 }
  validates :offer_price, presence: true, numericality: true
  validates :trigger_count, presence: true, numericality: { greater_than: 0 }
end
