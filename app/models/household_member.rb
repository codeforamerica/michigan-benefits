class HouseholdMember < ApplicationRecord
  belongs_to :app

  FILING_STATUSES = [
    :primary_tax_filer,
    :spouse_to_primary_filer,
    :dependent_claimed_by_someone_else_living_outside_the_home
  ]
  enum names: FILING_STATUSES.zip(FILING_STATUSES).to_h

  def full_name
    [first_name, last_name].join(" ")
  end
end
