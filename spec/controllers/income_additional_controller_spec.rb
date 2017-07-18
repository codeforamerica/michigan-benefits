# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomeAdditionalController, :member, type: :controller do
  let(:additional_income) do
    %w[
      unemployment
      ssi
      workers_comp
      pension
      social_security
      child_support
      foster_care
      other
    ]
  end

  let(:prefixed_additional_income) do
    additional_income.map { |k| "income_#{k}" }
  end

  let(:expected) do
    prefixed_additional_income.map { |k| [k, 1] }.to_h
  end

  let!(:current_app) do
    App.create!(
      expected.merge(user: @member, additional_income: additional_income)
    )
  end

  let(:step) { assigns(:step) }

  describe '#edit' do
    it 'assigns the fields to the step' do
      get :edit

      actual = prefixed_additional_income.map { |k| [k, step.send(k)] }.to_h

      expect(actual).to eq(expected)
    end

    it 'is skipped if there is no additional income' do
      current_app.update!(additional_income: [])
      get :edit
      expect(response).to be_redirect
    end
  end

  describe '#update' do
    let(:params) do
      prefixed_additional_income.map { |k| [k, 123] }.to_h
    end

    it 'updates the app' do
      expect do
        put :update, params: { step: params }
      end.to change {
        current_app.reload.attributes.slice(*prefixed_additional_income)
      }.to(params)
    end

    it 'redirects to the next step' do
      put :update, params: { step: params }

      expect(response).to redirect_to(step_path(IncomeOtherAssetsController))
    end
  end
end
