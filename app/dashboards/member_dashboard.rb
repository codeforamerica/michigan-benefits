require "administrate/base_dashboard"

class MemberDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    snap_application: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    marital_status: Field::String,
    sex: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    birthday: Field::DateTime,
    buy_food_with: Field::Boolean,
    relationship: Field::String,
    requesting_food_assistance: Field::Boolean,
    employment_status: Field::String,
    employed_employer_name: Field::String,
    employed_hours_per_week: Field::Number,
    employed_pay_quantity: Field::Number,
    employed_pay_interval: Field::String,
    self_employed_profession: Field::String,
    self_employed_monthly_income: Field::Number,
    self_employed_monthly_expenses: Field::String,
    citizen: Field::Boolean,
    disabled: Field::Boolean,
    new_mom: Field::Boolean,
    in_college: Field::Boolean,
    living_elsewhere: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    first_name
    last_name
    snap_application
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    snap_application
    id
    created_at
    updated_at
    marital_status
    sex
    first_name
    last_name
    birthday
    buy_food_with
    relationship
    requesting_food_assistance
    employment_status
    employed_employer_name
    employed_hours_per_week
    employed_pay_quantity
    employed_pay_interval
    self_employed_profession
    self_employed_monthly_income
    self_employed_monthly_expenses
    citizen
    disabled
    new_mom
    in_college
    living_elsewhere
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    marital_status
    sex
    first_name
    last_name
    birthday
    buy_food_with
    relationship
    requesting_food_assistance
    employment_status
    employed_employer_name
    employed_hours_per_week
    employed_pay_quantity
    employed_pay_interval
    self_employed_profession
    self_employed_monthly_income
    self_employed_monthly_expenses
    citizen
    disabled
    new_mom
    in_college
    living_elsewhere
  ].freeze

  # Overwrite this method to customize how members are displayed
  # across all pages of the admin dashboard.
  def display_resource(member)
    "#{member.first_name} #{member.last_name}"
  end
end
