# frozen_string_literal: true

require "rails_helper"

RSpec.describe HouseholdMoreInfoController, :member, type: :controller do
  let!(:current_app) do
    App.create!(attributes.merge(user: member))
  end

  let(:attributes) do
    {
      everyone_a_citizen: true,
      anyone_disabled: true,
      any_new_moms: true,
      anyone_in_college: true,
      anyone_living_elsewhere: true,
    }.with_indifferent_access
  end

  let(:step) do
    assigns(:step)
  end

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      attributes.each do |key, value|
        expect(step.send(key)).to eq(value)
      end
    end
  end

  describe "#update" do
    it "updates the app and redirects when valid" do
      params = {
        everyone_a_citizen: false,
        anyone_disabled: false,
        any_new_moms: false,
        anyone_in_college: false,
        anyone_living_elsewhere: false,
      }.with_indifferent_access

      put :update, params: { step: params }

      expect(current_app.reload.attributes).to include(params)
      expect(response).to redirect_to(step_path(HouseholdSituationsController))
    end

    it "sets the step and renders :edit otherwise" do
      params = {
        everyone_a_citizen: nil,
        anyone_disabled: nil,
        any_new_moms: nil,
        anyone_in_college: nil,
        anyone_living_elsewhere: nil,
      }

      put :update, params: { step: params }

      expect(step).to be_an_instance_of(HouseholdMoreInfo)
      expect(response).to render_template(:edit)
    end
  end
end
