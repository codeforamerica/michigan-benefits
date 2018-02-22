class CommonApplication < ApplicationRecord
  include CommonBenefitApplication

  has_many :members, class_name: "HouseholdMember", foreign_key: "common_application_id"

  def pdf
    @_pdf ||= ApplicationPdfAssembler.new(benefit_application: self).run
  end

  def documents
    []
  end
end
