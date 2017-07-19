# frozen_string_literal: true

class ExpensesAdditionalController < SimpleStepController
  ATTRIBUTES = %w[
    monthly_care_expenses
    monthly_medical_expenses
    monthly_court_ordered_expenses
    monthly_tax_deductible_expenses
  ].freeze

  ARRAY_ATTRIBUTES = {
    care_expenses: %w[
      childcare
      elderly_care
      disabled_adult_care
    ],
    medical_expenses: %w[
      health_insurance
      co_pays
      prescriptions
      dental
      in_home_care
      transportation
      hospital_bills
      other
    ],
    court_ordered_expenses: %w[
      child_support
      alimony
    ],
    tax_deductible_expenses: %w[
      student_loan_interest
      other_tax_deductible
    ]
  }.freeze

  def edit
    set_sections

    @step = step_class.new(
      current_app
        .attributes
        .slice(*ATTRIBUTES)
        .merge(array_to_checkboxes(ARRAY_ATTRIBUTES.keys.flat_map { |k| current_app[k] }))
    )
  end

  def update
    current_app.update!(
      step_params
        .slice(*ATTRIBUTES)
        .merge(ARRAY_ATTRIBUTES.map { |k, c| [k, checkboxes_to_array(c)] }.to_h)
    )

    redirect_to next_path
  end

  private

  def skip?
    sections.values.all?(&:!)
  end

  def sections
    @sections ||= current_app
      .attributes
      .slice('dependent_care', 'medical', 'court_ordered', 'tax_deductible')
      .symbolize_keys
  end

  alias set_sections sections
end
