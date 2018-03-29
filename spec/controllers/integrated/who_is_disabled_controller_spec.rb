require "rails_helper"

RSpec.describe Integrated::WhoIsDisabledController do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::WhoIsDisabledController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      context "when someone in household is disabled" do
        it "returns false" do
          application = create(:common_application,
            :multi_member,
            navigator: build(:application_navigator, anyone_disabled: true))

          skip_step = Integrated::WhoIsDisabledController.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when no one in household is disabled" do
        it "returns true" do
          application = create(:common_application,
            :multi_member,
            navigator: build(:application_navigator, anyone_disabled: false))

          skip_step = Integrated::WhoIsDisabledController.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_disabled: true),
          members: build_list(:household_member, 2, disabled: "yes"))
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.disabled_yes?).to eq(true)
        expect(form.members.second.disabled_yes?).to eq(true)
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
              disabled: "no",
            },
            member_2.id => {
              disabled: "yes",
            },
          },
        }
      end

      it "updates each member with disabled info" do
        current_app = create(:common_application, members: [member_1, member_2])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.disabled_no?).to be_truthy
        expect(member_2.disabled_yes?).to be_truthy
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
              disabled: "no",
            },
            member_2.id => {
              disabled: "no",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator, anyone_disabled: true))
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
