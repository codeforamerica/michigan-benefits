# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpensesAdditionalSource do
  it "validates that values are either true or false" do
    valid_trues_step = ExpensesAdditionalSource.new(
      court_ordered: true,
      dependent_care: true,
      medical: true,
      tax_deductible: true,
    )

    valid_falses_step = ExpensesAdditionalSource.new(
      court_ordered: false,
      dependent_care: false,
      medical: false,
      tax_deductible: false,
    )

    invalid_string_step = ExpensesAdditionalSource.new(
      court_ordered: "no",
      dependent_care: "no",
      medical: "no",
      tax_deductible: "no",
    )

    invalid_nil_step = ExpensesAdditionalSource.new(
      court_ordered: nil,
      dependent_care: nil,
      medical: nil,
      tax_deductible: nil,
    )

    expect(valid_trues_step).to be_valid
    expect(valid_falses_step).to be_valid
    expect(invalid_string_step).not_to be_valid
    expect(invalid_nil_step).not_to be_valid
  end
end
