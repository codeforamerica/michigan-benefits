# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomeChangeExplanationController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member, income_change: true))
  end

  let(:attributes) do
    {
      income_change_explanation: '1'
    }.with_indifferent_access
  end

  let(:step) do
    assigns(:step)
  end

  describe '#edit' do
    let(:skip_attributes) do
      {
        income_change: false
      }
    end

    it 'assigns the attributes to the step' do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end

    it 'skips if there was no income change' do
      current_app.update!(skip_attributes)

      get :edit

      expect(response).to redirect_to(step_path(IncomeCurrentlyEmployedController))
    end
  end

  describe '#update' do
    let(:params) do
      {
        step: {
          income_change_explanation: '2'
        }
      }
    end

    it 'updates attributes' do
      expect do
        put :update, params: params
      end.to change {
        current_app.reload.attributes.slice(*attributes.keys)
      }.from('income_change_explanation' => '1').to('income_change_explanation' => '2')
    end

    it 'redirects' do
      put :update, params: params
      expect(response).to redirect_to step_path(IncomeCurrentlyEmployedController)
    end
  end
end
