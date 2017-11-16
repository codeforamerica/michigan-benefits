require "rails_helper"

RSpec.describe Medicaid::TaxFilingWithHouseholdMembersMemberController do
  describe "#next_path" do
    it "is the tax filing   members relationship path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/tax-filing-with-household-members-relationship",
      )
    end
  end

  describe "#edit" do
    context "is single member" do
      it "skips this page" do
        medicaid_application = create(
          :medicaid_application,
          members: [create(:member)],
          filing_federal_taxes_next_year: true,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to(subject.next_path)
      end
    end

    context "is multi member" do
      context "is not filing federal taxes next year" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            members: create_list(:member, 2),
            filing_federal_taxes_next_year: false,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end

      context "is filing federal taxes next year" do
        context "is filing taxes with household members" do
          it "renders edit" do
            medicaid_application = create(
              :medicaid_application,
              members: create_list(:member, 2),
              filing_federal_taxes_next_year: true,
              filing_taxes_with_household_members: true,
            )
            session[:medicaid_application_id] = medicaid_application.id

            get :edit

            expect(response).to render_template(:edit)
          end
        end

        context "is not filing taxes with household members" do
          it "skips this page" do
            medicaid_application = create(
              :medicaid_application,
              members: create_list(:member, 2),
              filing_federal_taxes_next_year: true,
              filing_taxes_with_household_members: false,
            )

            session[:medicaid_application_id] = medicaid_application.id

            get :edit

            expect(response).to redirect_to(subject.next_path)
          end
        end
      end
    end
  end
end
