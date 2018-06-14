require "administrate/base_dashboard"

class CommonApplicationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    additional_information: Field::String.with_options(searchable: false),
    authorized_representative: Field::Enum,
    authorized_representative_name: Field::String,
    authorized_representative_phone: Field::String,
    created_at: Field::DateTime.with_options(searchable: false),
    email: Field::String,
    email_consented: Field::Enum.with_options(searchable: false),
    id: Field::Number,
    income_changed: Field::Enum,
    income_changed_explanation: Field::Text,
    less_than_threshold_in_accounts: Field::Enum,
    last_emailed_office_at: Field::DateTime,
    living_situation: Field::Enum,
    mailing_address: AddressField.with_options(class_name: "Address"),
    members: Field::HasMany.with_options(class_name: "HouseholdMember", limit: 20),
    office_location: Field::String.with_options(searchable: false),
    office_page: Field::String,
    paperwork: Field::String.with_options(searchable: false),
    phone_number: Field::String,
    previously_received_assistance: Field::Enum.with_options(searchable: false),
    properties: Field::String.with_options(searchable: false),
    residential_address: AddressField.with_options(class_name: "Address"),
    selected_office_location: Field::String,
    signature: Field::String,
    signed_at: Field::DateTime,
    sms_consented: Field::Enum.with_options(searchable: false),
    sms_phone_number: Field::String,
    updated_at: Field::DateTime.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    email
    office_location
    phone_number
    sms_consented
    signed_at
    last_emailed_office_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    members
    email
    office_location
    office_page
    selected_office_location
    residential_address
    mailing_address
    signature
    signed_at
    additional_information
    email_consented
    income_changed
    income_changed_explanation
    less_than_threshold_in_accounts
    living_situation
    paperwork
    phone_number
    previously_received_assistance
    properties
    sms_consented
    sms_phone_number
    authorized_representative
    authorized_representative_name
    authorized_representative_phone
    updated_at
    created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  ].freeze

  # Overwrite this method to customize how common applications are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(common_application)
    "Common Application ##{common_application.id}"
  end
end
