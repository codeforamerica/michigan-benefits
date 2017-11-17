require "rails_helper"

RSpec.describe Medicaid::TaxFilingWithHouseholdMembersRelationshipController do
  include_examples "application required"

  describe "#next_path" do
    it "is the income introduction path" do
      expect(subject.next_path).to eq(
        "/steps/medicaid/tax-overview",
      )
    end
  end

  describe "#update" do
    context "a household member selected 'Joint' as tax relationship" do
      it "updates primary member's tax relationship to 'Joint'" do
        primary_member = build(:member)
        secondary_member = build(:member,
          filing_taxes_with_primary_member: true)
        medicaid_application = create(
          :medicaid_application,
          members: [
            primary_member,
            secondary_member,
          ],
        )
        session[:medicaid_application_id] = medicaid_application.id

        put(
          :update,
          params: {
            step: {
              members: {
                secondary_member.id => {
                  tax_relationship: "Joint",
                },
              },
            },
          },
        )
        primary_member.reload
        secondary_member.reload

        expect(primary_member.tax_relationship).to eq("Joint")
        expect(secondary_member.tax_relationship).to eq("Joint")
      end
    end

    context "a household member selected 'Dependent' as tax relationship" do
      it "updates primary member's tax relationship to 'Single'" do
        primary_member = build(:member)
        secondary_member = build(:member,
          filing_taxes_with_primary_member: true)
        medicaid_application = create(
          :medicaid_application,
          members: [
            primary_member,
            secondary_member,
          ],
        )
        session[:medicaid_application_id] = medicaid_application.id

        put(
          :update,
          params: {
            step: {
              members: {
                secondary_member.id => {
                  tax_relationship: "Dependent",
                },
              },
            },
          },
        )
        primary_member.reload
        secondary_member.reload

        expect(primary_member.tax_relationship).to eq("Single")
        expect(secondary_member.tax_relationship).to eq("Dependent")
      end
    end

    describe "#edit" do
      context "multi-member household" do
        it "limits step members to non-primary members in tax household" do
          primary_member = build(:member)
          non_household_member = build(:member,
            filing_taxes_with_primary_member: false)
          household_member = build(:member,
            filing_taxes_with_primary_member: true)
          medicaid_application = create(
            :medicaid_application,
            members: [
              primary_member,
              non_household_member,
              household_member,
            ],
            filing_federal_taxes_next_year: true,
            filing_taxes_with_household_members: true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to render_template(:edit)
          expect(assigns(:step).members).to eq([household_member])
        end

        context "not filing federal taxes next year" do
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

        context "filing federal taxes next year, without household members" do
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

      context "single member household" do
        it "skips this page" do
          medicaid_application = create(
            :medicaid_application,
            members: [create(:member)],
            filing_federal_taxes_next_year: true,
            filing_taxes_with_household_members: true,
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          expect(response).to redirect_to(subject.next_path)
        end
      end
    end
  end
end
