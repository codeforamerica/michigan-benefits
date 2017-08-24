# frozen_string_literal: true

require "rails_helper"

RSpec.describe GeneralAnythingElseController do
  let(:step) { assigns(:step) }
  let(:step_class) { GeneralAnythingElse }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the attributes to the step" do
      session[:snap_application_id] = current_app.id

      get :edit
      step_attributes = attributes.keys.map do |attr|
        [attr, step.send(attr)]
      end.to_h

      expect(step_attributes).to eq(attributes)
    end
  end

  describe "#update" do
    context "When additional information is provided" do
      it "is valid" do
        put :update

        expect(response).to redirect_to("/steps/legal-agreement")
        expect(current_app.additional_information).to eq(
          attributes.fetch(:additional_information),
        )
      end
    end

    context "When additional information is NOT provided" do
      it "is valid" do
        current_app = create(:snap_application)

        put :update, params: { step: { additional_information: nil } }

        expect(response).to redirect_to("/steps/legal-agreement")
        expect(current_app.additional_information).to be_nil
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end

  def attributes
    { additional_information: "Thank you!" }
  end
end
