require "administrate/base_dashboard"

class RecurringChargeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    shop: Field::BelongsTo,
    id: Field::Number,
    type: Field::String,
    shopify_id: Field::Number,
    user_id: Field::Number,
    charge_data: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :shop,
    :id,
    :type,
    :shopify_id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shop,
    :id,
    :type,
    :shopify_id,
    :user_id,
    :charge_data,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :shop,
    :type,
    :shopify_id,
    :user_id,
    :charge_data,
  ].freeze

  # Overwrite this method to customize how recurring charges are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(recurring_charge)
  #   "RecurringCharge ##{recurring_charge.id}"
  # end
end
