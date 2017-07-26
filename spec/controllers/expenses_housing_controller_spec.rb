# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpensesHousingController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member))
  end

  let(:attributes) do
    ExpensesHousing.attribute_names.map do |k|
      [k, integer_type?(k) ? 123 : true]
    end.to_h
  end

  let(:step) do
    assigns(:step)
  end

  def integer_type?(k)
    App.columns_hash[k].type == :integer
  end

  describe "#edit" do
    pending "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:params) do
        {
          step: ExpensesHousing.attribute_names.map do |k|
            [k, integer_type?(k) ? 321 : false]
          end.to_h,
        }
      end

      pending "updates attributes" do
        expect do
          put :update, params: params
        end.to(
          change { current_app.reload.attributes.slice(*attributes.keys) },
        )
      end

      pending "redirects" do
        put :update, params: params
        expect(response).to redirect_to step_path(ExpensesAdditionalSourcesController)
      end
    end
  end
end
