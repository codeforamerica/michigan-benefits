require "rails_helper"

RSpec.describe Medicaid::ExpensesStudentLoanMemberController do
  describe "#next_path" do
    it "is the amounts overview page path" do
      expect(subject.next_path).to eq "/steps/medicaid/amounts-overview"
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_pay_student_loan_interest,
  )
end
