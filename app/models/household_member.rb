class HouseholdMember < ApplicationRecord
  belongs_to :app

  default_scope { order(id: :asc) }

  EMPLOYMENT_STATUSES = [
    :employed,
    :self_employed,
    :not_employed
  ]

  FILING_STATUSES = [
    :primary_tax_filer,
    :spouse_to_primary_filer,
    :dependent_claimed_by_someone_else_living_outside_the_home
  ]

  def full_name
    [first_name, last_name].join(" ")
  end

  def applicant?
    relationship == 'self'
  end
end
