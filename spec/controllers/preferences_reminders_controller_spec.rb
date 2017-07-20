# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreferencesRemindersController, :member, type: :controller do
  let(:params) do
    PreferencesReminders.attribute_names.map { |k| [k, true] }.to_h
  end

  let!(:current_app) do
    App.create!(params.merge(user: member))
  end

  let(:step) { assigns(:step) }

  describe '#edit' do
    it 'assigns the fields to the step' do
      get :edit

      expect(
        PreferencesReminders.attribute_names.map { |k| [k, step.send(k)] }.to_h
      ).to eq(params)
    end
  end

  describe '#update' do
    let(:valid_params) do
      PreferencesReminders.attribute_names.map { |k| [k, false] }.to_h
    end

    it 'updates the app' do
      expect do
        put :update, params: { step: valid_params }
      end.to change {
        current_app.reload.attributes.slice(*PreferencesReminders.attribute_names)
      }
    end

    it 'redirects to the next step' do
      put :update, params: { step: valid_params }

      expect(response).to redirect_to(
        step_path(PreferencesRemindersConfirmationController)
      )
    end
  end
end
