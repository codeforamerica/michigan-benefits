require "rails_helper"

RSpec.describe Integrated::DescribeTaxRelationshipsController do
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

            skip_step = Integrated::DescribeTaxRelationshipsController.skip?(application)
            expect(skip_step).to be_falsey
          end
        end

        context "when primary member is not filing taxes" do
          it "returns true" do
            application = create(:common_application, members: [
                                   build(:household_member, filing_taxes_next_year: "no"),
                                   build(:household_member),
                                 ])

            skip_step = Integrated::DescribeTaxRelationshipsController.skip?(application)
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
            ]
          )
          skip_step = Integrated::DescribeTaxRelationshipsController.skip?(application)
          expect(skip_step).to eq(true)
        end
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "scopes to non-applicant members and assigns existing attributes" do
        current_app = create(:common_application, members: [
                               build(:household_member),
                               build(:household_member, tax_relationship: "dependent"),
                             ])
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.members.first.tax_relationship).to eq("dependent")
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
            member_2.id => {
              tax_relationship: "dependent",
            },
          },
        }
      end

      it "updates each non-primary member with tax relationship info" do
        current_app = create(:common_application, members: [member_1, member_2])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        member_2.reload
        expect(member_2.tax_relationship).to eq("dependent")
      end
    end

    context "with invalid params" do
      let(:member_1) do
        create(:household_member, filing_taxes_next_year: "yes")
      end

      let(:member_2) do
        create(:household_member)
      end

      let(:invalid_params) do
        {
          members: {
            member_1.id => {
              tax_relationship: "dependent",
            },
            member_2.id => {
              tax_relationship: nil,
            },
          },
        }
      end

      it "renders edit without updating" do
        current_app = create(:common_application, members: [member_1, member_2])
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
