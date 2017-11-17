require "rails_helper"

RSpec.describe PersonalDetailController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { sex: "", marital_status: "" } } }
  let(:step_class) { PersonalDetail }

  before { session[:snap_application_id] = current_app.id }

  include_examples(
    "step controller",
    "param validation",
    "application required",
  )

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.sex).to eq("male")
      expect(step.marital_status).to eq("Married")
      expect(step.ssn).to eq("123456789")
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the app" do
        valid_params = {
          sex: "female",
          marital_status: "Divorced",
          ssn: "987654321",
        }

        put :update, params: { step: valid_params }

        current_app_member.reload

        valid_params.each do |key, value|
          expect(current_app_member.send(key)).to eq(value)
        end

        expect(response).to redirect_to("/steps/household-members-overview")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def current_app_member
    @_current_app_member ||= current_app.members.first
  end

  def member
    create(:member,
           sex: "male",
           marital_status: "Married",
           ssn: "123456789")
  end
end
