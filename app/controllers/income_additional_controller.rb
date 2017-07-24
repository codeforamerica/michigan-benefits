# frozen_string_literal: true

class IncomeAdditionalController < StandardStepsController
  def edit
    @additional_income = current_app.additional_income.map do |key|
      "income_#{key}"
    end

    @step = step_class.new(
      @additional_income.map { |k| [k, current_app[k]] }.to_h,
    )
  end

  private

  def skip?
    step_attrs.none? do |attr|
      current_app.additional_income.include?(attr.to_s.remove(/^income_/))
    end
  end
end
