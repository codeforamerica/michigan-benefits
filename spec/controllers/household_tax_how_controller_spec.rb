# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdTaxHowController, :member, type: :controller do
  let!(:current_app) do
    App.create!(
      user: member,
      household_tax: true,
      household_members: [household_member],
    )
  end

  let!(:household_member) do
    HouseholdMember.create!(
      first_name: "alice",
      filing_status: "primary_tax_filer",
    )
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    let(:skip_attributes) do
      {
        household_tax: false,
      }
    end

    pending "assigns the household members" do
      get :edit
      expect(step.household_members.map(&:first_name)).to eq(["alice"])
    end

    pending "skips if there are no situations" do
      current_app.update!(skip_attributes)

      get :edit

      expect(response).to redirect_to(step_path(IncomeIntroductionController))
    end
  end

  describe "#update" do
    let(:params) do
      {
        "filing_status" => "spouse_to_primary_filer",
      }
    end

    def do_put(param = household_member.to_param)
      put :update, params: {
        step: {
          household_members: {
            param => params,
          },
        },
      }
    end

    pending "updates the member attributes if they are present" do
      do_put
      expect(household_member.reload.attributes.slice(*params.keys)).to eq(params)
    end

    pending "does not update the member attributes if they are not present" do
      expect do
        do_put "doesnotexist"
      end.not_to(change { household_member.reload.attributes.slice(*params.keys) })
    end

    pending "only updates the situational attributes" do
      params["first_name"] = "bob"

      expect do
        do_put
      end.to raise_error(ActionController::UnpermittedParameters)

      expect(household_member.reload.first_name).to eq("alice")
    end

    pending "redirects to the next path" do
      do_put

      expect(response).to redirect_to(step_path(IncomeIntroductionController))
    end
  end
end
