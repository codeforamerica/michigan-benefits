# frozen_string_literal: true

class ExpensesAdditionalController < SnapStepsController
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
    care_expenses: SnapApplication::CARE_EXPENSES,
    medical_expenses: SnapApplication::MEDICAL_EXPENSES,
    court_ordered_expenses: SnapApplication::COURT_ORDERED_EXPENSES,
  }.freeze

  def edit
    set_sections

    @step = step_class.new(
      current_application.
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
      current_application.update!(update_params)
      redirect_to next_path
    else
      render :edit
    end
  end

  private

  def attribute_array
    ARRAY_ATTRIBUTES.keys.flat_map do |key|
      current_application[key]
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
    @previous_section ||= current_application.
      attributes.
      slice(*PREVIOUS_SECTION_ATTRIBUTES).
      symbolize_keys
  end

  alias set_sections previous_section
end
