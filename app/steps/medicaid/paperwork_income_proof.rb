module Medicaid
  class PaperworkIncomeProof < Step
    step_attributes(
      :id,
      :has_proof_of_income,
    )

    validates :id,
      presence: { message: "Can't find member ID. Please click back and answer question again." }

    validates :has_proof_of_income,
      presence: { message: "Make sure to answer this question" }
  end
end
