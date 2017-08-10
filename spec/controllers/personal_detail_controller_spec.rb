# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonalDetailController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { name: nil } } }
  let(:step_class) { PersonalDetail }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the name and birthday to the step" do
      get :edit

      expect(step.name).to eq("bob")
      expect(step.birthday).to eq(birthday)
    end
  end

  describe "#update" do
    context "valid params" do
      it "updates the application" do
        expect do
          put :update, params: valid_params
        end.to(
          change { current_app.reload.attributes.slice("name", "birthday") },
        )
      end

      it "redirects to the next step" do
        put :update, params: valid_params

        expect(response).to redirect_to("/steps/contact-information")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, birthday: birthday, name: "bob")
  end

  def valid_params
    {
      step: {
        name: "RJD2",
        "birthday(3i)" => "31",
        "birthday(2i)" => "1",
        "birthday(1i)" => "1950",
      },
    }
  end

  def birthday
    DateTime.parse("2/2/1945")
  end
end
