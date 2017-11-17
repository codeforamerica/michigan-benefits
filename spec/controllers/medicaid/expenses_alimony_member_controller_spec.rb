require "rails_helper"

RSpec.describe Medicaid::ExpensesAlimonyMemberController, type: :controller do
  include_examples "application required"

  describe "#next_path" do
    it "is the student loan expenses page path" do
      expect(subject.next_path).to eq "/steps/medicaid/expenses-student-loan"
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_pay_child_support_alimony_arrears,
  )
end
