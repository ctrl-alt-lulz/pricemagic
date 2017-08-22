class Product < ActiveRecord::Base
  belongs_to :shop
  has_many :variants, ->{ order(:created_at) }, dependent: :destroy
  has_many :price_tests, dependent: :destroy
  has_many :metrics, ->{ order(:created_at) }, dependent: :destroy 
  has_many :collects
  has_many :collections, through: :collects
  
  # Other validations
  # TODO add validation to make sure shopify_product_id is unique
  
  validates :shop_id, presence: true
  
  # ## TODO change name to be more descriptive
  # ## Should be singular, most_rece_google_metric?
  ## TODO figure out joins/includes, previous code doesn't work
  def most_recent_metrics
    variants.includes(:metrics).select{ |m| m if m.metrics.any? }.map {|m| m.metrics.last}
  end
  
  def main_variant
    variants.first
  end
  
  def latest_product_google_metric_views
    main_variant.metrics.last.try(:page_views).to_i
  end

  def latest_product_google_metric_views_at(date)
    main_variant.metrics.where('created_at < ?', date).last.try(:page_views).to_i
  end
end
