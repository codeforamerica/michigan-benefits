require "rails_helper"

RSpec.describe Integrated::WhoIsCaretakerController do
  describe "#skip?" do
    context "when multi member household" do
      context "when at least one person is applying for healthcare" do
        context "when someone in household is caretaker" do
          it "returns false" do
            application = create(:common_application,
              members: build_list(:household_member, 2, requesting_healthcare: "yes"),
              navigator: build(:application_navigator, anyone_caretaker: true))

            skip_step = Integrated::WhoIsCaretakerController.skip?(application)
            expect(skip_step).to be_falsey
          end
        end

        context "when no one in household is caretaker" do
          it "returns true" do
            application = create(:common_application,
              members: build_list(:household_member, 2, requesting_healthcare: "yes"),
              navigator: build(:application_navigator, anyone_caretaker: false))

            skip_step = Integrated::WhoIsCaretakerController.skip?(application)
            expect(skip_step).to be_truthy
          end
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_caretaker: true),
          members: build_list(:household_member, 2, caretaker: "yes"))
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.caretaker_yes?).to eq(true)
        expect(form.members.second.caretaker_yes?).to eq(true)
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
              caretaker: "no",
            },
            member_2.id => {
              caretaker: "yes",
            },
          },
        }
      end

      it "updates each member with caretaker info" do
        current_app = create(:common_application, members: [member_1, member_2])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.caretaker_no?).to be_truthy
        expect(member_2.caretaker_yes?).to be_truthy
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
              caretaker: "no",
            },
            member_2.id => {
              caretaker: "no",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator, anyone_caretaker: true))
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
