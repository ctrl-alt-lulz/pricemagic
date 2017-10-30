require "administrate/base_dashboard"

class ProductDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    shop: Field::BelongsTo,
    variants: Field::HasMany,
    price_tests: Field::HasMany,
    metrics: Field::HasMany,
    collects: Field::HasMany,
    collections: Field::HasMany,
    id: Field::Number,
    title: Field::String,
    shopify_product_id: Field::String,
    product_type: Field::String,
    tags: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    main_image_src: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :shop,
    :variants,
    :price_tests,
    :metrics,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shop,
    :variants,
    :price_tests,
    :metrics,
    :collects,
    :collections,
    :id,
    :title,
    :shopify_product_id,
    :product_type,
    :tags,
    :created_at,
    :updated_at,
    :main_image_src,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :shop,
    :variants,
    :price_tests,
    :metrics,
    :collects,
    :collections,
    :title,
    :shopify_product_id,
    :product_type,
    :tags,
    :main_image_src,
  ].freeze

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(product)
  #   "Product ##{product.id}"
  # end
end
