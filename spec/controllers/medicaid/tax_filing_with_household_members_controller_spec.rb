require "rails_helper"

RSpec.describe Medicaid::TaxFilingWithHouseholdMembersController do
  include_examples "application required"

  describe "#next_path" do
    it "is the tax filing with household members member path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/tax-filing-with-household-members-member",
      )
    end
  end

  describe "#update" do
    context "filing taxes with household members" do
      it "updates the application" do
        medicaid_application = create(
          :medicaid_application,
          members: create_list(:member, 2),
        )
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: {
          step: { filing_taxes_with_household_members: true },
        }

        medicaid_application.reload

        expect(
          medicaid_application,
        ).to be_filing_taxes_with_household_members
      end
    end

    context "not filing taxes with household members" do
      it "updates the application" do
        medicaid_application = create(
          :medicaid_application,
          members: create_list(:member, 2),
        )
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: {
          step: { filing_taxes_with_household_members: false },
        }

        medicaid_application.reload

        expect(
          medicaid_application,
        ).not_to be_filing_taxes_with_household_members
      end
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
        it "renders edit" do
          medicaid_application = create(
            :medicaid_application,
            members: create_list(:member, 2),
            filing_federal_taxes_next_year: true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
