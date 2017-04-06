class Views::Steps::ExpensesAdditional < Views::Base
  needs :app, :step, :f

  def content
    if app.dependent_care?
      h4 "Care Expenses", class: "step-section-header__headline"

      question f, :monthly_care_expenses, "In total, how much do you pay in care expenses each month?" do
        money_field f, :monthly_care_expenses
      end

      p "What kind of care expenses do you have?", class: 'form-question'
      grouped_checkbox f, :childcare, "Childcare"
      grouped_checkbox f, :elderly_care, "Elderly Care"
      grouped_checkbox f, :disabled_adult_care, "Disabled adult care"
    end

    if app.medical?
      h4 "Medical Expenses", class: "step-section-header__headline"

      question f, :monthly_medical_expenses, "In total, how much do you pay in medical expenses each month?" do
        money_field f, :monthly_medical_expenses
      end

      p "What kind of medical expenses do you have?", class: 'form-question'
      grouped_checkbox f, :health_insurance, "Health insurance"
      grouped_checkbox f, :co_pays, "Co-pays"
      grouped_checkbox f, :prescriptions, "Prescriptions"
      grouped_checkbox f, :dental, "Dental"
      grouped_checkbox f, :in_home_care, "In-home care"
      grouped_checkbox f, :transportation, "Transportation"
      grouped_checkbox f, :hospital_bills, "Hospital bills"
      grouped_checkbox f, :other, "Other"
    end

    if app.court_ordered?
      h4 "Court Ordered Expenses", class: "step-section-header__headline"

      question f, :monthly_court_ordered_expenses, "In total, how much do you pay in court ordered expenses each month?" do
        money_field f, :monthly_court_ordered_expenses
      end

      p "What kind of court ordered expenses do you have?", class: 'form-question'
      grouped_checkbox f, :child_support, "Child support"
      grouped_checkbox f, :alimony, "Alimony"
    end

    if app.tax_deductible?
      h4 "Tax Deductible Expenses", class: "step-section-header__headline"

      question f, :monthly_tax_deductible_expenses, "In total, how much do you pay in tax deductible expenses each month?" do
        money_field f, :monthly_tax_deductible_expenses
      end

      p "What kind of tax deductible expenses do you have?", class: 'form-question'
      grouped_checkbox f, :student_loan_interest, "Student loan interest"
      grouped_checkbox f, :other_tax_deductible, "Other"
    end
  end

  private

  def grouped_checkbox(f, name, label)
    div class: 'form-group form-group--compact',
      'data-field-type' => "checkbox",
      'data-md5' => Digest::MD5.hexdigest(label) do
      checkbox_field f, name, label
    end
  end
end
