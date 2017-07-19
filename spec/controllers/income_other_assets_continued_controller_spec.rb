# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomeOtherAssetsContinuedController, :member, type: :controller do
  let(:financial_accounts) do
    IncomeOtherAssetsContinued.attribute_names - ['total_money']
  end

  let!(:current_app) do
    App.create!(
      user: @member,
      total_money: 321,
      financial_accounts: financial_accounts,
      has_accounts: true
    )
  end

  let(:step) do
    assigns(:step)
  end

  describe '#edit' do
    it 'assigns the attributes to the step' do
      expected = financial_accounts
        .map { |key| [key, true] }
        .to_h
        .merge('total_money' => 321)

      get :edit

      actual = financial_accounts
        .map { |key| [key, step.send(key)] }
        .to_h
        .merge('total_money' => step.total_money)

      expect(actual).to eq(expected)
    end

    it 'skips if there are no accounts' do
      current_app.update!(has_accounts: false)

      get :edit

      expect(response).to redirect_to(step_path(ExpensesIntroductionController))
    end
  end

  describe '#update' do
    let(:params) do
      financial_accounts
        .map { |key| [key, false] }
        .to_h
        .merge('total_money' => 123)
    end

    it 'updates the app' do
      put :update, params: { step: params }

      current_app.reload

      expect(current_app.financial_accounts).to be_empty
      expect(current_app.total_money).to eq(123)
    end

    it 'redirects' do
      put :update, params: { step: params }
      expect(response).to redirect_to(step_path(ExpensesIntroductionController))
    end
  end
end
