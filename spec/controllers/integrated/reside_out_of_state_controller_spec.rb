require "rails_helper"

RSpec.describe Integrated::ResideOutOfStateController do
  describe "skip?" do
    context "when applicant is a resident of state" do
      it "returns true" do
        navigator = build(:application_navigator, resides_in_state: true)
        application = create(:common_application, navigator: navigator)

        skip_step = Integrated::ResideOutOfStateController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when applicant is resident of another state" do
      it "returns false" do
        navigator = build(:application_navigator, resides_in_state: false)
        application = create(:common_application, navigator: navigator)

        skip_step = Integrated::ResideOutOfStateController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end
end
