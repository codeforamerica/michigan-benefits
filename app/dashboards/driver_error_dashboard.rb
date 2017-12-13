require "administrate/base_dashboard"

class DriverErrorDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    page_history: Field::String,
    snap_application: Field::HasOne,
    id: Field::Number,
    error_class: Field::String,
    error_message: Field::String,
    page_class: Field::String,
    backtrace: Field::String,
    page_html: HtmlCodeField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    snap_application
    error_class
    error_message
    page_class
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    error_class
    error_message
    page_class
    page_history
    backtrace
    page_html
    created_at
    updated_at
    snap_application
  ].freeze
end
