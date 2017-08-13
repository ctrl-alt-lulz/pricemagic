class Product < ActiveRecord::Base
  
  belongs_to :shop
  has_many :variants, dependent: :destroy
  has_many :price_tests, dependent: :destroy
  has_many :metrics, dependent: :destroy
  has_many :collects
  has_many :collections, through: :collects
  
    # Other validations
  # TODO add validation to make sure shopify_product_id is unique
  
  validates :shop_id, presence: true
end
