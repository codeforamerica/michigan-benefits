require "rails_helper"

RSpec.describe Integrated::IncludeAnyoneElseOnTaxesController do
  describe "#skip?" do
    context "when multi-member household" do
      context "when primary member is applying for healthcare" do
        context "when primary member is filing taxes" do
          it "returns false" do
            application = create(:common_application,
              members: [
                build(:household_member, requesting_healthcare: "yes", filing_taxes_next_year: "yes"),
                build(:household_member),
              ])

            skip_step = Integrated::IncludeAnyoneElseOnTaxesController.skip?(application)
            expect(skip_step).to be_falsey
          end
        end

        context "when primary member is not filing taxes" do
          it "returns true" do
            application = create(:common_application,
              members: [
                build(:household_member, filing_taxes_next_year: "no"),
                build(:household_member),
              ])

            skip_step = Integrated::IncludeAnyoneElseOnTaxesController.skip?(application)
            expect(skip_step).to eq(true)
          end
        end
      end

      context "when primary member is not applying for healthcare" do
        it "returns true" do
          application = create(:common_application,
            members: [
              build(:household_member, requesting_healthcare: "no"),
              build(:household_member),
            ])

          skip_step = Integrated::IncludeAnyoneElseOnTaxesController.skip?(application)
          expect(skip_step).to eq(true)
        end
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          anyone_else_on_tax_return: "false",
        }
      end

      it "updates the models" do
        current_app = create(:common_application, :multi_member,
          navigator: build(:application_navigator))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.anyone_else_on_tax_return).to be_falsey
      end
    end
  end
end
