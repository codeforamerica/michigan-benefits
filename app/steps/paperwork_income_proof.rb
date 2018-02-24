class PaperworkIncomeProof < Step
  step_attributes(
    :id,
    :has_proof_of_income,
  )

  validates_presence_of :id, :has_proof_of_income
end
