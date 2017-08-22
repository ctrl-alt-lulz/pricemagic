class Collect < ActiveRecord::Base
  belongs_to :product
  belongs_to :collection

  delegate :shop, to: :product
  delegate :shopify_product_id, to: :product 
  delegate :shopify_collection_id, to: :collection 
end
