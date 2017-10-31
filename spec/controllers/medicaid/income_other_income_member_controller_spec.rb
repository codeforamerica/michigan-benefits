require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeMemberController, type: :controller do
  describe "#next_path" do
    it "is the citizen selector page path" do
      expect(subject.next_path).to eq "/steps/medicaid/income-other-income-type"
    end
  end

  it_should_behave_like "Medicaid multi-member controller", :anyone_other_income
end
