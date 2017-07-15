# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomeOtherAssetsController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: @member))
  end

  let(:attributes) do
    {
      has_accounts: true,
      has_home: true,
      has_vehicle: true,
    }.with_indifferent_access
  end

  let(:step) do
    assigns(:step)
  end

  describe '#edit' do
    it 'assigns the attributes to the step' do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end
  end

  describe '#update' do
    context 'with valid params' do
      let(:params) do
        {
          step: {
            has_accounts: false,
            has_home: false,
            has_vehicle: false,
          }
        }
      end

      it 'updates attributes' do
        expect do
          put :update, params: params
        end.to change {
          current_app.reload.attributes.slice(*attributes.keys)
        }.from('has_accounts' => true, 'has_home' => true, 'has_vehicle' => true).
          to('has_accounts' => false, 'has_home' => false, 'has_vehicle' => false)
      end

      it 'redirects' do
        put :update, params: params
        expect(response).to redirect_to step_path(IncomeOtherAssetsContinued)
      end
    end

    context 'with invalid params' do
      it 're-renders' do
        put :update, params: { step: {} }
        expect(response).to render_template :edit
        expect(assigns(:step)).to be_an_instance_of(IncomeOtherAssets)
      end
    end
  end
end
