require "rails_helper"

RSpec.describe Medicaid::TaxClaimedAsDependentController do
  include_examples "application required"

  describe "#next_path" do
    it "is the tax filing with household members path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/tax-filing-with-household-members",
      )
    end
  end

  describe "#update" do
    context "claimed as dependent" do
      it "updates the primary member" do
        member = create(:member)

        medicaid_application = create(
          :medicaid_application,
          members: [member],
        )
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: { step: { claimed_as_dependent: true } }

        member.reload

        expect(member).to be_claimed_as_dependent
      end
    end

    context "not claimed as dependent" do
      it "updates the primary member" do
        member = create(:member)

        medicaid_application = create(
          :medicaid_application,
          members: [member],
        )
        session[:medicaid_application_id] = medicaid_application.id

        put :update, params: { step: { claimed_as_dependent: false } }

        member.reload

        expect(member).not_to be_claimed_as_dependent
      end
    end
  end

  describe "#edit" do
    context "is filing federal taxes next year" do
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

    context "is not filing federal taxes next year" do
      it "renders edit" do
        medicaid_application = create(
          :medicaid_application,
          members: [create(:member)],
          filing_federal_taxes_next_year: false,
        )
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
