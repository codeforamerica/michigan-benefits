class CommonApplication < ApplicationRecord
  include Submittable

  has_one :navigator,
    class_name: "ApplicationNavigator",
    foreign_key: "common_application_id",
    dependent: :destroy

  has_many :members,
    -> { order "created_at" },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id",
    dependent: :destroy

  has_many :food_applying_members,
    -> {
      requesting_food
    },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id"

  has_many :healthcare_applying_members,
    -> {
      requesting_healthcare
    },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id"

  has_many :tax_household_members,
    -> {
      tax_household
    },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id"

  has_many :food_household_members,
    -> {
      requesting_food.buy_and_prepare_food_together
    },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id"

  has_many :expenses

  enum previously_received_assistance: { unfilled: 0, yes: 1, no: 2 }, _prefix: :previously_received_assistance
  enum living_situation: { unknown_living_situation: 0, stable_address: 1, temporary_address: 2, homeless: 3 }
  enum income_changed: { unfilled: 0, yes: 1, no: 2 }, _prefix: :income_changed

  delegate :display_name, to: :primary_member

  def single_member_household?
    members.count == 1
  end

  def unstable_housing?
    temporary_address? || homeless?
  end

  def pdf
    @_pdf ||= ApplicationPdfAssembler.new(benefit_application: self).run
  end

  def residential_zip; end

  def office_location; end

  def documents
    []
  end

  def primary_member
    members.first
  end

  def non_applicant_members
    members - [primary_member]
  end

  def applying_for_food_assistance?
    members.any?(&:requesting_food_yes?)
  end

  def applying_for_healthcare?
    members.any?(&:requesting_healthcare_yes?)
  end

  def filing_taxes_jointly?
    members.any?(&:tax_relationship_married_filing_jointly?)
  end

  def filing_taxes_separately?
    members.any?(&:tax_relationship_married_filing_separately?)
  end

  def filing_taxes_with_dependent?
    members.any?(&:tax_relationship_dependent?)
  end

  def spouse_filing_taxes_jointly
    if filing_taxes_jointly?
      members.where(tax_relationship: "married_filing_jointly").first
    end
  end

  def spouse_filing_taxes_separately
    if filing_taxes_separately?
      members.where(tax_relationship: "married_filing_separately").first
    end
  end

  def dependents
    if filing_taxes_with_dependent?
      members.where(tax_relationship: "dependent")
    end
  end

  def anyone_employed?
    members.map { |member| member.job_count || 0 }.sum.positive?
  end

  def anyone_additional_income?
    members.map { |member| member.incomes.count || 0 }.sum.positive?
  end

  def anyone_additional_income_of?(income_type)
    members.map { |member| member.incomes.where(income_type: income_type.to_s).count || 0 }.sum.positive?
  end
end
