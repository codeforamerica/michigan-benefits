# frozen_string_literal: true

class HouseholdHealthSituations < ManyMemberUpdateStep
  self.title = 'Your Household'
  self.subhead = 'Ok, let us know which people these situations apply to.'

  def skip?
    !@app.any_medical_bill_help_last_3_months &&
      !@app.any_lost_insurance_last_3_months
  end
end
