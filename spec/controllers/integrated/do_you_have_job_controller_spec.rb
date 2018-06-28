require "rails_helper"

RSpec.describe Integrated::DoYouHaveJobController do
  describe "#skip?" do
    context "when in a multi-member household" do
      it "returns true" do
        application = create(:common_application, :multi_member)

        skip_step = Integrated::DoYouHaveJobController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "when current job is true" do
      let(:valid_params) do
        { current_job: "true" }
      end

      it "updates the navigator and adds a job for primary member" do
        primary_member = build(:household_member, employments: [])
        current_app = create(:common_application, :with_navigator, members: [primary_member])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.current_job).to be_truthy
        expect(current_app.primary_member.employments.count).to eq(1)
      end
    end

    context "when current job is false" do
      let(:valid_params) do
        { current_job: "false" }
      end

      it "updates the navigator and zeroes out jobs for primary member" do
        primary_member = build(:household_member, employments: build_list(:employment, 1))
        current_app = create(:common_application, :with_navigator, members: [primary_member])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload
        primary_member.reload

        expect(current_app.navigator.current_job).to be_falsey
        expect(current_app.primary_member.employments.count).to eq(0)
      end
    end
  end
end
