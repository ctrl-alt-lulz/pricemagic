class Metric < ActiveRecord::Base
  validates :page_title, presence: true
  validates :page_revenue, numericality: true, presence: true
  validates :page_avg_price, numericality: true, presence: true
  validates :page_views, numericality: true, presence: true
  validates :product, presence: true
  validates :shop, presence: true
  validates :variant, presence: true

  belongs_to :shop
  belongs_to :product
  belongs_to :variant

  def product_and_variant_name=(product_variant_string)
    self.product = Product.where(title: product_variant_string.split(' - ').first).first
    if product
      if product.variants.where(variant_title: product_variant_string.split(' - ').last).first.nil?
        self.variant = product.variants.where(variant_title: "Default Title").first
      else
        self.variant = product.variants.where(variant_title: product_variant_string.split(' - ').last).first
      end
    end
  end
  
  def page_revenue=(price)
    if price.is_a? String
      self.page_revenue = price.to_f 
    else
      super
    end
  end
  
  def page_views=(views)
    if views.is_a? String
      self.page_views = views.to_i
    else
      super
    end
  end
  
  def page_avg_price=(price)
    if price.is_a? String
      self.page_avg_price = price.to_i
    else
      super
    end
  end
  
  def self.bulk_metric_create_from_google!(shop_id, data_object)
    shop = Shop.find(shop_id)
    data_object.reports[0].data.rows.map do |row|
      shop.metrics.create(
        product_and_variant_name: row.dimensions[0],
        page_title: row.dimensions[0],
        page_revenue: row.metrics[0].values[0],
        page_views: row.metrics[0].values[1],
        page_avg_price: row.metrics[0].values[2],
        acquired_at: Time.now
         )
    end
  end
end