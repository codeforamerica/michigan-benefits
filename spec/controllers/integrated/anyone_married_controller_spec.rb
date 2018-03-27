require "rails_helper"

RSpec.describe Integrated::AnyoneMarriedController do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::AnyoneMarriedController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      context "anyone is married" do
        it "returns true" do
          application = create(:common_application,
            navigator: build(:application_navigator, anyone_married: true),
            members: build_list(:household_member, 2))

          skip_step = Integrated::AnyoneMarriedController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end

      context "no one is married" do
        it "returns false" do
          application = create(:common_application,
            navigator: build(:application_navigator, anyone_married: false),
            members: build_list(:household_member, 2))

          skip_step = Integrated::AnyoneMarriedController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          anyone_married: "true",
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          navigator: build(:application_navigator),
          members: build_list(:household_member, 2))
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change {
          current_app.reload
          current_app.navigator.anyone_married?
        }.to eq(true)
      end
    end
  end
end
