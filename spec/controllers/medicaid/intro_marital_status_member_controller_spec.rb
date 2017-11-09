require "rails_helper"

RSpec.describe Medicaid::IntroMaritalStatusMemberController do
  describe "#next_path" do
    it "is the intro college path" do
      expect(subject.next_path).to eq "/steps/medicaid/intro-college"
    end
  end

  it_should_behave_like(
    "Medicaid multi-member controller",
    :anyone_married,
  )
end
