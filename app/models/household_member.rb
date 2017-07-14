# frozen_string_literal: true

class HouseholdMember < ApplicationRecord
  belongs_to :app

  default_scope { order(id: :asc) }

  EMPLOYMENT_STATUSES = %w[
    employed
    self_employed
    not_employed
  ].freeze

  FILING_STATUSES = %w[
    primary_tax_filer
    spouse_to_primary_filer
    dependent_claimed_by_someone_else_living_outside_the_home
    i_do_not_know
  ].freeze

  PAY_INTERVALS = %w[
    day
    week
    2-weeks
    month
  ].freeze

  def income_inconsistent?
    !income_consistent
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def name(for_header: false)
    if for_header && applicant?
      "#{first_name.titleize} (that’s you!)"
    else
      first_name.titleize
    end
  end

  def applicant?
    relationship == 'self'
  end

  def employed?
    employment_status == 'employed'
  end

  def self_employed?
    employment_status == 'self_employed'
  end

  def unemployed?
    employment_status == 'not_employed'
  end
end
