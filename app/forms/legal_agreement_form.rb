class LegalAgreementForm < Form
  set_navigator_attributes(:agree_to_terms)

  validates :agree_to_terms,
    presence: { message: "To submit this application, please agree to the terms." }
end
