require "administrate/base_dashboard"

class EmploymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    member: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    employer_name: Field::String,
    hours_per_week: Field::Number,
    pay_quantity: Field::String,
    payment_frequency: Field::String,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    member
    employer_name
    hours_per_week
    pay_quantity
    payment_frequency
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    member
    id
    created_at
    employer_name
    hours_per_week
    pay_quantity
    payment_frequency
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    member
    employer_name
    hours_per_week
    pay_quantity
    payment_frequency
  ].freeze

  # Overwrite this method to customize how employments are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(employment)
  #   "Employment ##{employment.id}"
  # end
end
