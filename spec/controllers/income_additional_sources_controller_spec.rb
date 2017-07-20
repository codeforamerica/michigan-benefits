# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomeAdditionalSourcesController, :member, type: :controller do
  let(:additional_income) do
    IncomeAdditionalSources.attribute_names.map(&:to_s)
  end

  let!(:current_app) do
    App.create!(
      user: member,
      additional_income: additional_income
    )
  end

  let(:step) do
    assigns(:step)
  end

  describe '#edit' do
    it 'assigns the attributes to the step' do
      expected = additional_income.map { |key| [key, true] }.to_h

      get :edit

      actual = additional_income.map { |key| [key, step.send(key)] }.to_h

      expect(actual).to eq(expected)
    end
  end

  describe '#update' do
    let(:params) do
      additional_income.map { |key| [key, false] }.to_h
    end

    it 'updates the app' do
      put :update, params: { step: params }

      expect(current_app.reload.additional_income).to be_empty
    end

    it 'redirects' do
      put :update, params: { step: params }
      expect(response).to redirect_to(step_path(IncomeAdditionalController))
    end
  end
end
