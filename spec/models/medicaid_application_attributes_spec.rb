require "rails_helper"

RSpec.describe MedicaidApplicationAttributes do
  describe "#to_h" do
    context "unstable housing" do
      it "returns residential address as Homeless" do
        medicaid_application = create(
          :medicaid_application,
          stable_housing: false,
        )

        data = MedicaidApplicationAttributes.new(
          medicaid_application: medicaid_application,
        ).to_h

        expect(data).to include(
          residential_address_street_address: "Homeless",
        )
      end
    end

    describe "insurance types" do
      it_should_behave_like "insurance type", "medicaid", "Medicaid"
      it_should_behave_like "insurance type", "medicare", "Medicare"
      it_should_behave_like "insurance type", "chip", "CHIP/MIChild"
      it_should_behave_like "insurance type", "va", "VA health care programs"
      it_should_behave_like "insurance type",
        "employer", "Employer or individual plan"
      it_should_behave_like "insurance type", "other", "Other"
    end
  end
end
