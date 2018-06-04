require "rails_helper"

RSpec.describe Integrated::WhoIsHealthcareEnrolledController do
  describe "#skip?" do
    context "when multi member household" do
      context "when someone in household is healthcare_enrolled" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes"),
            navigator: build(:application_navigator, anyone_healthcare_enrolled: true))

          skip_step = Integrated::WhoIsHealthcareEnrolledController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when no one in household is healthcare_enrolled" do
        it "returns true" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes"),
            navigator: build(:application_navigator, anyone_healthcare_enrolled: false))

          skip_step = Integrated::WhoIsHealthcareEnrolledController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_healthcare_enrolled: true),
          members: build_list(:household_member, 2, healthcare_enrolled: "yes"))

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.healthcare_enrolled_yes?).to eq(true)
        expect(form.members.second.healthcare_enrolled_yes?).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:member_1) do
        create(:household_member)
      end

      let(:member_2) do
        create(:household_member)
      end

      let(:valid_params) do
        {
          members: {
            member_1.id => {
              healthcare_enrolled: "no",
            },
            member_2.id => {
              healthcare_enrolled: "yes",
            },
          },
        }
      end

      it "updates each member with healthcare_enrolled info" do
        current_app = create(:common_application, members: [member_1, member_2])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.healthcare_enrolled_no?).to be_truthy
        expect(member_2.healthcare_enrolled_yes?).to be_truthy
      end
    end

    context "with invalid params" do
      let(:member_1) do
        create(:household_member)
      end

      let(:member_2) do
        create(:household_member)
      end

      let(:invalid_params) do
        {
          members: {
            member_1.id => {
              healthcare_enrolled: "no",
            },
            member_2.id => {
              healthcare_enrolled: "no",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator, anyone_healthcare_enrolled: true))

        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
