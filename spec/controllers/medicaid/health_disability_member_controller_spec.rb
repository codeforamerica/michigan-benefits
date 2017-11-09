require "rails_helper"

RSpec.describe Medicaid::HealthDisabilityMemberController, type: :controller do
  describe "#next_path" do
    it "is the pregnancy question page path" do
      expect(subject.next_path).to eq "/steps/medicaid/health-pregnancy"
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_disabled,
  )
end
