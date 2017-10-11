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
  
  def first_variant_price
    main_variant.variant_price
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
  
  def has_active_price_test?
    price_tests.empty? ? "False" : price_tests.last.active.to_s.capitalize
  end
  alias_method :has_active_price_test, :has_active_price_test?
  
  def price_test_completion_percentage
    price_tests.any? ? price_tests.last.completion_percentage : 0
  end
  
  def as_json(options={})
    super(:methods => [:variants, :has_active_price_test, :price_test_completion_percentage])
  end
end
