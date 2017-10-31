require "rails_helper"

RSpec.describe Medicaid::IntroCollegeMemberController do
  describe "#next_path" do
    it "is the intro citizen path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/intro-citizen",
      )
    end
  end

  it_should_behave_like "Medicaid multi-member controller", :anyone_in_college
end
