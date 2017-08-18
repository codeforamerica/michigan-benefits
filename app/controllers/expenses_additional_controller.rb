# frozen_string_literal: true

class ExpensesAdditionalController < StepsController
  PREVIOUS_SECTION_ATTRIBUTES = %w[
    court_ordered
    dependent_care
    medical
  ].freeze

  ATTRIBUTES = %w[
    monthly_care_expenses
    monthly_medical_expenses
    monthly_court_ordered_expenses
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
  }.freeze

  def edit
    set_sections

    @step = step_class.new(
      current_snap_application.
        attributes.
        slice(*ATTRIBUTES).
        merge(array_to_checkboxes(attribute_array)),
    )
  end

  def update
    update_params = step_params.
      slice(*ATTRIBUTES).
      merge(attribute_hash)
    @step = step_class.new(update_params)

    if @step.valid?
      current_snap_application.update!(update_params)
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(application_attributes)
  end

  def application_attributes
    app = current_snap_application

    {
      monthly_care_expenses: app.monthly_care_expenses,
      monthly_medical_expenses: app.monthly_medical_expenses,
      monthly_court_ordered_expenses: app.monthly_court_ordered_expenses,
      care_expenses: app.care_expenses,
      medical_expenses: app.medical_expenses,
      court_ordered_expenses: app.court_ordered_expenses,
    }
  end

  def attribute_array
    ARRAY_ATTRIBUTES.keys.flat_map do |key|
      current_snap_application[key]
    end
  end

  def attribute_hash
    ARRAY_ATTRIBUTES.map do |k, c|
      [k, checkboxes_to_array(c)]
    end.to_h
  end

  def skip?
    @_skip ||= previous_page_all_false?
  end

  def previous_page_all_false?
    previous_section.values.all?(&:!)
  end

  def previous_section
    @previous_section ||= current_snap_application.
      attributes.
      slice(*PREVIOUS_SECTION_ATTRIBUTES).
      symbolize_keys
  end

  alias set_sections previous_section
end
