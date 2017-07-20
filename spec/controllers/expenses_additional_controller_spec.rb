# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesAdditionalController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member, dependent_care: true))
  end

  let(:money_attributes) do
    described_class::ATTRIBUTES.map { |k| [k, 123] }.to_h
  end

  let(:attributes) do
    money_attributes.merge(described_class::ARRAY_ATTRIBUTES)
  end

  let(:expected) do
    money_attributes.merge(
      described_class::ARRAY_ATTRIBUTES.values.flatten.map do |v|
        [v, true]
      end.to_h
    )
  end

  let(:step) { assigns(:step) }

  describe '#edit' do
    it 'assigns the fields to the step' do
      get :edit

      actual = ExpensesAdditional.attribute_names.map do |k|
        [k, step.send(k)]
      end.to_h

      expect(actual).to eq(expected)
    end

    it 'is skipped if there is no additional income' do
      current_app.update!(dependent_care: false)
      get :edit
      expect(response).to be_redirect
    end
  end

  describe '#update' do
    let(:params) do
      expected.keys.map do |k|
        [k, k.is_a?(Numeric) ? 321 : false]
      end.to_h
    end

    it 'updates the app' do
      expect do
        put :update, params: { step: params }
      end.to change {
        current_app.reload.attributes.slice(*attributes.keys)
      }
    end

    it 'redirects to the next step' do
      put :update, params: { step: params }

      expect(response).to redirect_to(step_path(PreferencesRemindersController))
    end
  end
end
