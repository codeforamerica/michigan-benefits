require "rails_helper"

RSpec.describe Integrated::AddTaxMemberController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          first_name: "Princess",
          last_name: "Caroline",
          tax_relationship: "dependent",
        }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: valid_params }
        end.to change { current_app.members.count }.by 1

        member = current_app.members.last
        expect(member.first_name).to eq("Princess")
        expect(member.last_name).to eq("Caroline")
        expect(member.tax_relationship_dependent?).to be_truthy
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          first_name: "Princess",
          last_name: "Caroline",
          tax_relationship: nil,
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
