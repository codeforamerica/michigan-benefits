require "administrate/base_dashboard"

class ExportDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    benefit_application: Field::Polymorphic,
    id: Field::Number,
    destination: Field::String,
    metadata: Field::String,
    force: Field::Boolean,
    status: Field::String,
    completed_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    completed_at
    destination
    metadata
    benefit_application
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    benefit_application
    destination
    metadata
    force
    status
    completed_at
    created_at
    updated_at
  ].freeze
end
