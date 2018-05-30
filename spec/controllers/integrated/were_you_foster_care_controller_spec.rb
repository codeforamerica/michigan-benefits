require "rails_helper"

RSpec.describe Integrated::WereYouFosterCareController do
  describe "#skip?" do
    context "when household has one member" do
      context "when member is between 18 and 26 years old" do
        it "returns false" do
          application = create(:common_application, members: [
                                 build(:household_member, requesting_healthcare: "yes", birthday: 20.years.ago),
                               ])

          skip_step = Integrated::WereYouFosterCareController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when member is not between 18 and 26 years old" do
        it "returns true" do
          application = create(:common_application, members: [
                                 build(:household_member, requesting_healthcare: "yes", birthday: 30.years.ago),
                               ])

          skip_step = Integrated::WereYouFosterCareController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          foster_care_at_18: "yes",
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          :single_member,
          navigator: build(:application_navigator))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.foster_care_at_18_yes?).to eq(true)
      end
    end
  end
end
