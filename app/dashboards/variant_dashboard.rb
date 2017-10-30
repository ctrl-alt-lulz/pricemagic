require "administrate/base_dashboard"

class VariantDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    product: Field::BelongsTo,
    metrics: Field::HasMany,
    id: Field::Number,
    shopify_variant_id: Field::String,
    variant_title: Field::String,
    variant_price: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    unit_cost: Field::Number.with_options(decimals: 2),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :product,
    :metrics,
    :id,
    :shopify_variant_id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :product,
    :metrics,
    :id,
    :shopify_variant_id,
    :variant_title,
    :variant_price,
    :created_at,
    :updated_at,
    :unit_cost,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :product,
    :metrics,
    :shopify_variant_id,
    :variant_title,
    :variant_price,
    :unit_cost,
  ].freeze

  # Overwrite this method to customize how variants are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(variant)
  #   "Variant ##{variant.id}"
  # end
end
