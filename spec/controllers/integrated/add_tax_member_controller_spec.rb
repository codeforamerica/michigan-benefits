require "rails_helper"

RSpec.describe Integrated::AddTaxMemberController do
  it_behaves_like "add member controller",
                  tax_relationship: "dependent",
                  tax_relationship_spouse: "married_filing_jointly"

  describe "#update" do
    context "with valid params" do
      context "dependent" do
        let(:valid_params) do
          {
            first_name: "Princess",
            last_name: "Caroline",
            relationship: "child",
            tax_relationship: "dependent",
          }
        end

        it "updates the tax relationship" do
          current_app = create(:common_application)
          session[:current_application_id] = current_app.id

          expect do
            put :update, params: { form: valid_params }
          end.to change { current_app.members.count }.by 1

          member = current_app.members.last

          expect(member.tax_relationship_dependent?).to be_truthy
        end
      end

      context "spouse" do
        let(:valid_params) do
          {
            first_name: "Princess",
            last_name: "Caroline",
            relationship: "spouse",
            tax_relationship_spouse: "married_filing_separately",
          }
        end

        it "updates the tax relationship" do
          current_app = create(:common_application,
                               navigator: build(:application_navigator),
                               members: [build(:household_member)])
          session[:current_application_id] = current_app.id

          expect do
            put :update, params: { form: valid_params }
          end.to change { current_app.members.count }.by 1

          current_app.reload
          member = current_app.members.last

          expect(member.tax_relationship_married_filing_separately?).to be_truthy
        end
      end
    end
  end
end
