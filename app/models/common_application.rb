class CommonApplication < ApplicationRecord
  include CommonBenefitApplication
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

  has_many :snap_applying_members,
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

  has_many :snap_household_members,
    -> {
      requesting_food.buy_and_prepare_food_together
    },
    class_name: "HouseholdMember",
    foreign_key: "common_application_id"

  enum previously_received_assistance: { unfilled: 0, yes: 1, no: 2 },
       _prefix: :previously_received_assistance

  enum living_situation: { unknown_living_situation: 0, stable_address: 1, temporary_address: 2, homeless: 3 }

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

  def applying_for_food_assistance?
    members.each do |member|
      return true if member.requesting_food_yes?
    end
    false
  end
end
