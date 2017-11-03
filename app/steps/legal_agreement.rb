class LegalAgreement < Step
  step_attributes(
    :consent_to_terms,
  )

  validates(
    :consent_to_terms,
    inclusion: {
      in: %w(true),
      message: "To submit this application, please agree to the terms.",
    },
  )
end
