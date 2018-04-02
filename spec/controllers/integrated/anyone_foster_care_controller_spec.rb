require "rails_helper"

RSpec.describe Integrated::AnyoneFosterCareController do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::AnyoneFosterCareController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      it "returns false if anyone is between the age of 18 and 26" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, birthday: 20.years.ago))

        skip_step = Integrated::AnyoneFosterCareController.skip?(application)
        expect(skip_step).to be_falsey
      end

      it "returns false if anyone has no birthday specified" do
        application = create(:common_application,
                             members: build_list(:household_member, 2))

        skip_step = Integrated::AnyoneFosterCareController.skip?(application)
        expect(skip_step).to be_falsey
      end

      it "returns true if no one is between the age of 18 and 26" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, birthday: 30.years.ago))

        skip_step = Integrated::AnyoneFosterCareController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end
  end

  describe "#update" do
    context "when true" do
      let(:valid_params) do
        {
          anyone_foster_care_at_18: "true",
        }
      end

      it "updates the application navigator" do
        current_app = create(:common_application,
          :multi_member,
          navigator: build(:application_navigator, anyone_foster_care_at_18: false))
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.anyone_foster_care_at_18?
        }.to eq(true)
      end
    end

    context "when false" do
      let(:valid_params) do
        {
          anyone_foster_care_at_18: "false",
        }
      end

      it "updates the application navigator and household members" do
        current_app = create(:common_application,
          members: build_list(:household_member, 2, foster_care_at_18: "yes"),
          navigator: build(:application_navigator, anyone_foster_care_at_18: true))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.anyone_foster_care_at_18?).to be_falsey
        expect(current_app.primary_member.foster_care_at_18_no?).to be_truthy
      end
    end
  end
end
