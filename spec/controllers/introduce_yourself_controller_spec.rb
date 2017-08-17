# frozen_string_literal: true

require "rails_helper"

RSpec.describe IntroduceYourselfController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { first_name: nil } } }
  let(:step_class) { IntroduceYourself }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the name and birthday to the step" do
      get :edit

      expect(step.first_name).to eq("bob")
      expect(step.last_name).to eq("booboo")
      expect(step.birthday).to eq(birthday)
    end
  end

  describe "#update" do
    context "valid params" do
      it "updates the application" do
        expect do
          put :update, params: valid_params
        end.to(
          change do
            current_app.primary_member.reload.attributes.slice(
              "first_name",
              "last_name",
              "birthday",
            )
          end,
        )
      end

      it "redirects to the next step" do
        put :update, params: valid_params

        expect(response).to redirect_to("/steps/contact-information")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def member
    create(:member, first_name: "bob", last_name: "booboo", birthday: birthday)
  end

  def valid_params
    {
      step: {
        first_name: "RJ",
        last_name: "D2",
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
