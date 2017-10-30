require "administrate/base_dashboard"

class PriceTestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    product: Field::BelongsTo,
    id: Field::Number,
    percent_increase: Field::Number.with_options(decimals: 2),
    percent_decrease: Field::Number.with_options(decimals: 2),
    price_data: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    active: Field::Boolean,
    ending_digits: Field::Number.with_options(decimals: 2),
    price_points: Field::Number,
    current_price_started_at: Field::DateTime,
    view_threshold: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :product,
    :id,
    :percent_increase,
    :percent_decrease,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :product,
    :id,
    :percent_increase,
    :percent_decrease,
    :price_data,
    :created_at,
    :updated_at,
    :active,
    :ending_digits,
    :price_points,
    :current_price_started_at,
    :view_threshold,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :product,
    :percent_increase,
    :percent_decrease,
    :price_data,
    :active,
    :ending_digits,
    :price_points,
    :current_price_started_at,
    :view_threshold,
  ].freeze

  # Overwrite this method to customize how price tests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(price_test)
  #   "PriceTest ##{price_test.id}"
  # end
end
