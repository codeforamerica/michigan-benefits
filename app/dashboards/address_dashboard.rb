require "administrate/base_dashboard"

class AddressDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    benefit_application: Field::Polymorphic,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    street_address: Field::String,
    city: Field::String,
    county: Field::String,
    state: Field::String,
    zip: Field::String,
    mailing: Field::Boolean,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    benefit_application
    created_at
    updated_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    benefit_application
    id
    created_at
    updated_at
    street_address
    city
    county
    state
    zip
    mailing
  ].freeze

  FORM_ATTRIBUTES = %i[
    benefit_application
    street_address
    city
    county
    state
    zip
    mailing
  ].freeze
end
