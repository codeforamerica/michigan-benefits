require "rails_helper"

RSpec.describe Integrated::SelfEmploymentDetailsController do
  describe "#skip?" do
    context "when no applicants are self-employed" do
      it "returns true" do
        application = create(:common_application,
          members: [
            build(:household_member, self_employed: "no"),
            build(:household_member, self_employed: nil),
          ])

        skip_step = Integrated::SelfEmploymentDetailsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "edit" do
    context "when primary member is self-employed" do
      it "assigns the primary member's self-employment" do
        primary_member = build(:household_member,
          self_employed: "yes",
          self_employment_description: "cake baker")
        secondary_member = build(:household_member,
          self_employed: "yes",
          self_employment_description: "cookie eater")

        current_app = create(:common_application,
          members: [
            primary_member,
            secondary_member,
          ])

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.id).to eq(primary_member.id)
        expect(form.self_employment_description).to eq("cake baker")
      end
    end

    context "when primary member is not self-employed" do
      it "assigns the next self-employed member's details" do
        primary_member = build(:household_member, self_employed: "no")
        secondary_member = build(:household_member,
          self_employed: "yes",
          self_employment_description: "cookie eater")

        current_app = create(:common_application,
          members: [
            primary_member,
            secondary_member,
          ])

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.id).to eq(secondary_member.id)
        expect(form.self_employment_description).to eq("cookie eater")
      end
    end
  end

  describe "#update" do
    let(:member) do
      create(:household_member, self_employed: "yes")
    end

    context "when member to update belongs to current application" do
      context "with valid params" do
        let(:valid_params) do
          {
            id: member.id.to_s,
            self_employment_description: "cake baker",
            self_employment_income: "100",
            self_employment_expense: "50",
          }
        end

        it "updates the models" do
          current_app = create(:common_application,
            members: [member])

          session[:current_application_id] = current_app.id

          put :update, params: { form: valid_params }

          member.reload

          expect(member.self_employment_description).to eq("cake baker")
          expect(member.self_employment_income).to eq(100)
          expect(member.self_employment_expense).to eq(50)
        end
      end

      context "with invalid params" do
        let(:invalid_params) do
          {
            id: member.id.to_s,
            self_employment_income: "boo",
          }
        end

        it "renders edit without updating" do
          current_app = create(:common_application,
            members: [member])

          session[:current_application_id] = current_app.id

          put :update, params: { form: invalid_params }

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
