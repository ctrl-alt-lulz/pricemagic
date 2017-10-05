class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :metrics, dependent: :destroy
  
  # def latest_variant_google_metric_revenue_at(date)
  #   metrics.where('created_at < ?', date).last.try(:page_revenue).to_f
  # end
  
  def latest_variant_google_metric_revenue
    metrics.last.try(:page_revenue).to_f
  end
end
