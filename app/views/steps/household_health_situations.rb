# frozen_string_literal: true

class Views::Steps::HouseholdHealthSituations < Views::Base
  needs :app, :step, :f

  def content
    if app.any_medical_bill_help_last_3_months
      household_question f,
                         :medical_help,
                         'Who needs help paying for medical bills?',
                         app.household_members
    end

    if app.any_lost_insurance_last_3_months
      household_question f,
                         :insurance_lost_last_3_months,
                         'Who had insurance through a job and lost it in the last 3 months?',
                         app.household_members
    end
  end
end
