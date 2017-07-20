# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdHealthController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member))
  end

  let(:attributes) do
    {
      any_medical_bill_help_last_3_months: true,
      any_lost_insurance_last_3_months: true
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
            any_medical_bill_help_last_3_months: false,
            any_lost_insurance_last_3_months: false
          }
        }
      end

      it 'updates attributes' do
        expect do
          put :update, params: params
        end.to change {
          current_app.reload.attributes.slice(*attributes.keys)
        }.from('any_medical_bill_help_last_3_months' => true, 'any_lost_insurance_last_3_months' => true)
          .to('any_medical_bill_help_last_3_months' => false, 'any_lost_insurance_last_3_months' => false)
      end

      it 'redirects' do
        put :update, params: params
        expect(response).to redirect_to step_path(HouseholdHealthSituationsController)
      end
    end

    context 'with invalid params' do
      it 're-renders' do
        put :update, params: { step: {} }
        expect(response).to render_template :edit
        expect(assigns(:step)).to be_an_instance_of HouseholdHealth
      end
    end
  end
end
