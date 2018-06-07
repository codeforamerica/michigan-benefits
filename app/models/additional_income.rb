class AdditionalIncome < ApplicationRecord
  belongs_to :household_member

  INCOME_SOURCES = {
    unemployment: "Unemployment",
    pension: "Pension",
    retirement: "Retirement",
    social_security: "Social Security",
    ssi: "Supplemental Security Income (SSI) or Disability",
    alimony: "Alimony",
    child_support: "Child Support",
    workers_comp: "Worker's Compensation",
  }.freeze

  INCOME_SOURCES_HEALTHCARE_ONLY = {
    unemployment: "Unemployment",
    pension: "Pension",
    retirement: "Retirement",
    social_security: "Social Security",
    alimony: "Alimony",
  }.freeze

  def self.all_income_types
    INCOME_SOURCES.keys
  end

  validates :income_type, inclusion: { in: all_income_types.map(&:to_s),
                                       message: "%<value>s is not a valid income source" }

  def display_name
    INCOME_SOURCES[income_type.to_sym]
  end
end
