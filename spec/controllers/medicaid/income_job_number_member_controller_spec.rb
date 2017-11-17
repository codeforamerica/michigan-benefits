require "rails_helper"

RSpec.describe Medicaid::IncomeJobNumberMemberController do
  include_examples "application required"

  describe "#next_path" do
    it "is the self employment page path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/income-self-employment",
      )
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_employed,
  )
end
