require "rails_helper"

RSpec.describe Integrated::ReviewHealthcareHouseholdController do
  describe "#skip?" do
    context "when primary member is not applying for healthcare" do
      it "returns true" do
        application = create(:common_application, members: [create(:household_member, requesting_healthcare: "no")])

        skip_step = Integrated::ReviewHealthcareHouseholdController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when primary member is applying for healthcare" do
      it "returns false" do
        application = create(:common_application, members: [
                               create(:household_member, requesting_healthcare: "yes"),
                             ])

        skip_step = Integrated::ReviewHealthcareHouseholdController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "#edit" do
    context "filing taxes" do
      it "sets removable members and removed members" do
        application = create(:common_application,
          members: [
           create(:household_member, requesting_healthcare: "no", filing_taxes_next_year: "yes"),
           create(:household_member, requesting_healthcare: "no"),
           create(:household_member, requesting_healthcare: "no", tax_relationship: "not_included"),
         ])
        session[:current_application_id] = application.id

        get :edit

        removable_members = assigns(:removable_members)
        removed_household_members = assigns(:removed_household_members)
        expect(removable_members.count).to eq 1
        expect(removed_household_members.count).to eq 1
      end
    end

    context "not filing taxes" do
      it "sets removable members and removed members" do
        application = create(:common_application,
          :with_navigator,
          members: [
           create(:household_member, requesting_healthcare: "no", filing_taxes_next_year: "no"),
           create(:household_member, requesting_healthcare: "no"),
         ])
        session[:current_application_id] = application.id

        get :edit

        removable_members = assigns(:removable_members)
        removed_household_members = assigns(:removed_household_members)
        expect(removable_members.count).to eq(1)
        expect(removed_household_members).to be_empty
      end
    end
  end
end
