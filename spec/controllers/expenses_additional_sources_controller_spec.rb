# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpensesAdditionalSourcesController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member))
  end

  let(:attributes) do
    ExpensesAdditionalSources.attribute_names.map { |k| [k, false] }.to_h
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:params) do
        {
          step: ExpensesAdditionalSources.attribute_names.map { |k| [k, true] }.to_h,
        }
      end

      it "updates attributes" do
        expect do
          put :update, params: params
        end.to change {
          current_app.reload.attributes.slice(*attributes.keys)
        }
      end

      it "redirects" do
        put :update, params: params
        expect(response).to redirect_to step_path(ExpensesAdditionalController)
      end
    end

    context "with invalid params" do
      it "re-renders" do
        put :update, params: { step: {} }
        expect(response).to render_template :edit
        expect(assigns(:step)).to be_an_instance_of(ExpensesAdditionalSources)
      end
    end
  end
end
