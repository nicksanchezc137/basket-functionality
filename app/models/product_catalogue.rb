class ProductCatalogue < ApplicationRecord
  # Associations
  has_many :delivery_charges, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :offer_products, class_name: 'Offer', foreign_key: 'offer_product_catalogue_id', dependent: :destroy
  has_many :baskets, dependent: :destroy

  # Validations
  validates :product_name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :image_url, length: { maximum: 255 }, allow_blank: true
end
