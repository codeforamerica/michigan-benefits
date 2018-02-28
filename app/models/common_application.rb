class CommonApplication < ApplicationRecord
  include CommonBenefitApplication
  include Submittable

  has_one :navigator,
    class_name: "ApplicationNavigator",
    foreign_key: "common_application_id",
    dependent: :destroy

  has_many :members,
    class_name: "HouseholdMember",
    foreign_key: "common_application_id",
    dependent: :destroy

  def pdf
    @_pdf ||= ApplicationPdfAssembler.new(benefit_application: self).run
  end

  def residential_zip; end

  def office_location; end

  def documents
    []
  end
end
