require "administrate/base_dashboard"

class MetricDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    shop: Field::BelongsTo,
    product: Field::BelongsTo,
    variant: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    page_title: Field::String,
    page_revenue: Field::Number.with_options(decimals: 2),
    page_views: Field::Number,
    page_avg_price: Field::Number.with_options(decimals: 2),
    acquired_at: Field::DateTime,
    page_unique_purchases: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :shop,
    :product,
    :variant,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shop,
    :product,
    :variant,
    :id,
    :created_at,
    :updated_at,
    :page_title,
    :page_revenue,
    :page_views,
    :page_avg_price,
    :acquired_at,
    :page_unique_purchases,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :shop,
    :product,
    :variant,
    :page_title,
    :page_revenue,
    :page_views,
    :page_avg_price,
    :acquired_at,
    :page_unique_purchases,
  ].freeze

  # Overwrite this method to customize how metrics are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(metric)
  #   "Metric ##{metric.id}"
  # end
end
