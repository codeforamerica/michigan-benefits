require "rails_helper"

RSpec.describe Integrated::WhoIs<%= model_name %>>Controller do
  describe "#skip?" do
    context "when single member household" do
      it "returns true" do
        application = create(:common_application, :single_member)

        skip_step = Integrated::WhoIs<%= model_name %>>Controller.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when multi member household" do
      context "when someone in household is <%= model_method %>" do
        it "returns false" do
          application = create(:common_application,
            :multi_member,
            navigator: build(:application_navigator, anyone_<%= model_method %>: true))

          skip_step = Integrated::WhoIs<%= model_name %>>Controller.skip?(application)
          expect(skip_step).to be_falsey
        end
      end

      context "when no one in household is <%= model_method %>" do
        it "returns true" do
          application = create(:common_application,
            :multi_member,
            navigator: build(:application_navigator, anyone_<%= model_method %>: false))

          skip_step = Integrated::WhoIs<%= model_name %>>Controller.skip?(application)
          expect(skip_step).to be_truthy
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, anyone_<%= model_method %>: true),
          members: build_list(:household_member, 2, <%= model_method %>: "yes"))

        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.<%= model_method %>_yes?).to eq(true)
        expect(form.members.second.<%= model_method %>_yes?).to eq(true)
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
              <%= model_method %>: "no",
            },
            member_2.id => {
              <%= model_method %>: "yes",
            },
          },
        }
      end

      it "updates each member with <%= model_method %> info" do
        current_app = create(:common_application, members: [member_1, member_2])

        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_1.reload
        member_2.reload

        expect(member_1.<%= model_method %>_no?).to be_truthy
        expect(member_2.<%= model_method %>_yes?).to be_truthy
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
              <%= model_method %>: "no",
            },
            member_2.id => {
              <%= model_method %>: "no",
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application,
          members: [member_1, member_2],
          navigator: build(:application_navigator, anyone_<%= model_method %>: true))

        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
