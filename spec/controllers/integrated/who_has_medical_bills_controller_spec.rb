require "rails_helper"

RSpec.describe Integrated::WhoHasMedicalBillsController do
  describe "#skip?" do
    context "when multi member household" do
      context "when someone in household is medical_bills" do
        it "returns false" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes"),
            navigator: build(:application_navigator, anyone_medical_bills: true))

          skip_step = Integrated::WhoHasMedicalBillsController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when no one in household is medical_bills" do
        it "returns true" do
          application = create(:common_application,
            members: build_list(:household_member, 2, requesting_healthcare: "yes"),
            navigator: build(:application_navigator, anyone_medical_bills: false))

          skip_step = Integrated::WhoHasMedicalBillsController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_medical_bills: true),
          members: build_list(:household_member, 2, medical_bills: "yes"))

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.medical_bills_yes?).to eq(true)
        expect(form.members.second.medical_bills_yes?).to eq(true)
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
              medical_bills: "no",
            },
            member_2.id => {
              medical_bills: "yes",
            },
          },
        }
      end

      it "updates each member with medical_bills info" do
        current_app = create(:common_application, members: [member_1, member_2])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.medical_bills_no?).to be_truthy
        expect(member_2.medical_bills_yes?).to be_truthy
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
              medical_bills: "no",
            },
            member_2.id => {
              medical_bills: "no",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator, anyone_medical_bills: true))

        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
