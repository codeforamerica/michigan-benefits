require "rails_helper"

RSpec.describe Integrated::AnyoneHealthcareEnrolledController do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::AnyoneHealthcareEnrolledController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      it "returns false" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::AnyoneHealthcareEnrolledController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#update" do
    context "when true" do
      let(:valid_params) do
        {
          anyone_healthcare_enrolled: "true",
        }
      end

      it "updates the application navigator" do
        current_app = create(:common_application,
          :multi_member,
          navigator: build(:application_navigator, anyone_healthcare_enrolled: false))

        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.anyone_healthcare_enrolled?
        }.to eq(true)
      end
    end

    context "when false" do
      let(:valid_params) do
        {
          anyone_healthcare_enrolled: "false",
        }
      end

      it "updates the application navigator and household members" do
        current_app = create(:common_application,
          members: build_list(:household_member, 2, healthcare_enrolled: "yes"),
          navigator: build(:application_navigator, anyone_healthcare_enrolled: true))

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.anyone_healthcare_enrolled?).to be_falsey
        expect(current_app.primary_member.healthcare_enrolled_no?).to be_truthy
      end
    end
  end
end
