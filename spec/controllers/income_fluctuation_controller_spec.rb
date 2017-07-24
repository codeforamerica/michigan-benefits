# frozen_string_literal: true

require "rails_helper"

RSpec.describe IncomeFluctuationController, :member, type: :controller do
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
      income_consistent: false,
    )
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    it "assigns the household members" do
      get :edit
      expect(step.household_members.map(&:first_name)).to eq(["alice"])
    end

    it "skips if nobody is employed or self employed" do
      household_member.update!(income_consistent: true)

      get :edit

      expect(response).to redirect_to(step_path(IncomeAdditionalSourcesController))
    end
  end

  describe "#update" do
    context "when valid" do
      let(:params) do
        {
          expected_income_this_year: 123,
          expected_income_next_year: 123,
        }.stringify_keys
      end

      it "updates the member attributes if they are present" do
        do_put
        expect(household_member.reload.attributes.slice(*params.keys)).to eq(params)
      end

      it "does not update the member attributes if they are not present" do
        expect do
          do_put param: "doesnotexist"
        end.not_to(change { household_member.reload.attributes.slice(*params.keys) })
      end

      it "only updates the pertinent attributes" do
        params["first_name"] = "bob"

        expect do
          do_put
        end.to raise_error(ActionController::UnpermittedParameters)

        expect(household_member.reload.first_name).to eq("alice")
      end

      it "redirects to the next path" do
        do_put

        expect(response).to redirect_to(step_path(IncomeAdditionalSourcesController))
      end
    end

    def do_put(param: household_member.to_param, params: self.params)
      put :update, params: {
        step: {
          household_members: {
            param => params,
          },
        },
      }
    end
  end
end
