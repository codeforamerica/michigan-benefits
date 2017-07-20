# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdSituationsController, :member, type: :controller do
  let!(:current_app) do
    App.create!(user: member, household_members: [household_member])
  end

  let!(:household_member) do
    HouseholdMember.create!(
      first_name: 'alice',
      is_citizen: false,
      is_disabled: false,
      is_new_mom: false,
      in_college: false,
      is_living_elsewhere: false
    )
  end

  let(:step) do
    assigns(:step)
  end

  describe '#edit' do
    let(:skip_attributes) do
      {
        everyone_a_citizen: true,
        anyone_disabled: false,
        any_new_moms: false,
        anyone_in_college: false,
        anyone_living_elsewhere: false
      }
    end

    it 'assigns the household members' do
      get :edit
      expect(step.household_members.map(&:first_name)).to eq(['alice'])
    end

    it 'skips if there are no situations' do
      current_app.update!(skip_attributes)

      get :edit

      expect(response).to redirect_to(step_path(HouseholdHealthController))
    end
  end

  describe '#update' do
    let(:params) do
      {
        is_citizen: true,
        is_disabled: true,
        is_new_mom: true,
        in_college: true,
        is_living_elsewhere: true
      }.stringify_keys
    end

    def do_put(param = household_member.to_param)
      put :update, params: {
        step: {
          household_members: {
            param => params
          }
        }
      }
    end

    it 'updates the member attributes if they are present' do
      do_put
      expect(household_member.reload.attributes.slice(*params.keys)).to eq(params)
    end

    it 'does not update the member attributes if they are not present' do
      expect do
        do_put 'doesnotexist'
      end.not_to(change { household_member.reload.attributes.slice(*params.keys) })
    end

    it 'only updates the situational attributes' do
      params['first_name'] = 'bob'

      expect do
        do_put
      end.to raise_error(ActionController::UnpermittedParameters)

      expect(household_member.reload.first_name).to eq('alice')
    end

    it 'redirects to the next path' do
      do_put

      expect(response).to redirect_to(step_path(HouseholdHealthController))
    end
  end
end
