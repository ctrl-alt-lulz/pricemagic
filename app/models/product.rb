class Product < ActiveRecord::Base
  # Other validations
  # TODO add validation to make sure shopify_product_id is unique
  has_many :variants, dependent: :destroy
end
