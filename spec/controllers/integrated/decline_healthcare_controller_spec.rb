require "rails_helper"

RSpec.describe Integrated::DeclineHealthcareController do
  describe "#skip?" do
    context "when FAP only" do
      it "returns true" do
        application = create(:common_application,
          navigator: build(:application_navigator,
            applying_for_healthcare: false,
            applying_for_food: true))

        skip_step = Integrated::DeclineHealthcareController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when FAP and MA" do
      context "when anyone applying for healthcare" do
        it "returns true" do
          application = create(:common_application,
            members: [
              build(:household_member, requesting_healthcare: "yes"),
            ],
            navigator: build(:application_navigator,
             applying_for_healthcare: true,
             applying_for_food: true))

          skip_step = Integrated::DeclineHealthcareController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end

      context "when no one is applying for healthcare" do
        it "returns false" do
          application = create(:common_application,
            members: [
              build(:household_member),
              build(:household_member, requesting_healthcare: "no"),
            ],
            navigator: build(:application_navigator,
             applying_for_healthcare: true,
             applying_for_food: true))

          skip_step = Integrated::DeclineHealthcareController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end
    end
  end
end
