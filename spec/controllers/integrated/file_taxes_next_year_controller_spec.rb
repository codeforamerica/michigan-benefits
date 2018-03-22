require "rails_helper"

RSpec.describe Integrated::FileTaxesNextYearController do
  describe "#skip?" do
    context "when no one is requesting healthcare" do
      it "returns true" do
        application = create(:common_application, members: [
                               create(:household_member, requesting_healthcare: "no"),
                             ])

        skip_step = Integrated::FileTaxesNextYearController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when primary member is not requesting healthcare" do
      it "returns true" do
        application = create(:common_application, members: [
                               create(:household_member, requesting_healthcare: "no"),
                               create(:household_member, requesting_healthcare: "yes"),
                             ])

        skip_step = Integrated::FileTaxesNextYearController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "when one or more members are requesting healthcare, including primary member" do
      it "returns false" do
        application = create(:common_application, members: [
                               create(:household_member, requesting_healthcare: "yes"),
                             ])

        skip_step = Integrated::FileTaxesNextYearController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#update" do
    context "when filing taxes next year" do
      let(:valid_params) do
        {
          filing_taxes_next_year: "yes",
        }
      end

      it "updates the primary member and tax relationship" do
        current_app = create(:common_application, :single_member)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.filing_taxes_next_year_yes?).to be_truthy
        expect(current_app.primary_member.tax_relationship_primary?).to be_truthy
      end
    end
  end

  context "when not filing taxes next year" do
    let(:valid_params) do
      {
        filing_taxes_next_year: "no",
      }
    end

    it "updates the primary member" do
      current_app = create(:common_application, :single_member)
      session[:current_application_id] = current_app.id

      put :update, params: { form: valid_params }

      current_app.reload

      expect(current_app.primary_member.filing_taxes_next_year_no?).to be_truthy
      expect(current_app.primary_member.tax_relationship_unfilled?).to be_truthy
    end
  end
end
