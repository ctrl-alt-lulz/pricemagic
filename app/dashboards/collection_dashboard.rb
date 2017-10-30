require "administrate/base_dashboard"

class CollectionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    collects: Field::HasMany,
    products: Field::HasMany,
    id: Field::Number,
    title: Field::String,
    shopify_collection_id: Field::String,
    collection_type: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :collects,
    :products,
    :id,
    :title,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :collects,
    :products,
    :id,
    :title,
    :shopify_collection_id,
    :collection_type,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :collects,
    :products,
    :title,
    :shopify_collection_id,
    :collection_type,
  ].freeze

  # Overwrite this method to customize how collections are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(collection)
  #   "Collection ##{collection.id}"
  # end
end
