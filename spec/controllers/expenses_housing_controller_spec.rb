# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesHousingController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: @member))
  end

  let(:attributes) do
    ExpensesHousing.attribute_names.map do |k|
      [k, App.columns_hash[k].type == :integer ? 123 : true]
    end.to_h
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
          step: ExpensesHousing.attribute_names.map do |k|
            [k, App.columns_hash[k].type == :integer ? 321 : false]
          end.to_h
        }
      end

      it 'updates attributes' do
        expect do
          put :update, params: params
        end.to change {
          current_app.reload.attributes.slice(*attributes.keys)
        }
      end

      it 'redirects' do
        put :update, params: params
        expect(response).to redirect_to step_path(ExpensesAdditionalSources)
      end
    end
  end
end
