# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdPersonalDetailsController, :member, type: :controller do
  let(:params) do
    {
      sex: 'female',
      ssn: '123-45-6789',
      marital_status: 'divorced'
    }
  end

  let!(:current_app) do
    App.create!(user: @member, marital_status: params[:marital_status])
  end

  let(:step) { assigns(:step) }

  before do
    current_app.applicant.update!(params.slice(:ssn, :sex))
  end

  describe '#edit' do
    it 'assigns the correct step' do
      get :edit
      expect(step).to be_an_instance_of HouseholdPersonalDetails
    end

    it 'assigns the fields to the step' do
      get :edit

      params.each do |key, value|
        expect(step.send(key)).to eq(value)
      end
    end
  end

  describe '#update' do
    context 'when valid' do
      let(:valid_params) do
        {
          sex: 'male',
          ssn: '432-50-3432',
          marital_status: 'single'
        }
      end

      it 'updates the app' do
        put :update, params: { step: valid_params }

        current_app.reload

        expect(current_app.marital_status).to eq('single')
        expect(current_app.applicant.sex).to eq('male')
        expect(current_app.applicant.ssn).to eq('432-50-3432')
      end

      it 'redirects to the next step' do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to(step_path(HouseholdMembersOverviewController.to_param))
      end
    end

    it 'renders edit if the step is invalid' do
      put :update, params: { step: { sex: 'hahahahah' } }

      expect(assigns(:step)).to be_an_instance_of(HouseholdPersonalDetails)
      expect(response).to render_template(:edit)
    end
  end
end
