# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreferencesForInterviewController, :member, type: :controller do
  let(:params) do
    {
      preference_for_interview: 'telephone_interview'
    }
  end

  let!(:current_app) do
    App.create!(params.merge(user: @member))
  end

  let(:step) { assigns(:step) }

  describe '#edit' do
    it 'assigns the fields to the step' do
      get :edit
      expect(step.preference_for_interview).to eq('telephone_interview')
    end
  end

  describe '#update' do
    context 'when valid' do
      let(:valid_params) do
        {
          preference_for_interview: 'in_person_interview'
        }
      end

      it 'updates the app' do
        expect do
          put :update, params: { step: valid_params }
        end.to change { current_app.reload.preference_for_interview }
      end

      it 'redirects to the next step' do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to(step_path(PreferencesAnythingElseController))
      end
    end

    context 'when not valid' do
      it 'renders :edit' do
        put :update, params: {}
        expect(response).to render_template(:edit)
      end

      it 'sets the step' do
        put :update, params: {}
        expect(step).to be_an_instance_of(described_class.step_class)
      end
    end
  end
end
