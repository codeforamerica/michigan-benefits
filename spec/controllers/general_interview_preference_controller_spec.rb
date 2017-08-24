# frozen_string_literal: true

require "rails_helper"

RSpec.describe GeneralInterviewPreferenceController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { interview_preference: "telepathy" } } }
  let(:step_class) { GeneralInterviewPreference }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq(
        attributes,
      )
    end
  end

  describe "#update" do
    context "the preference is for a telephone interview" do
      it "is valid" do
        params = { interview_preference: "telephone" }

        put :update, params: { step: params }

        expect(response).to redirect_to("/steps/general-anything-else")
        expect(current_app.interview_preference).to eq("telephone")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end

  def attributes
    { interview_preference: "telephone" }
  end
end
