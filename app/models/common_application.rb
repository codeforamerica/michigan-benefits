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

  enum previously_received_assistance: { unfilled: 0, yes: 1, no: 2 },
       _prefix: :previously_received_assistance

  enum living_situation: { unknown_living_situation: 0, stable_address: 1, temporary_address: 2, homeless: 3 }

  def pdf
    @_pdf ||= ApplicationPdfAssembler.new(benefit_application: self).run
  end

  def residential_zip; end

  def office_location; end

  def documents
    []
  end
end
