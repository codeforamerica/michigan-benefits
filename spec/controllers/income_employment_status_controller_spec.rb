require "rails_helper"

RSpec.describe IncomeEmploymentStatusController do
  let(:step) { assigns(:step) }
  let(:member) do
    create(:member, sex: "male", relationship: "Child")
  end
  let(:invalid_params) do
    {
      step: {
        members: {
          member.id => { employment_status: "" },
        },
      },
    }
  end

  let(:step_class) { IncomeEmploymentStatus }

  before { session[:snap_application_id] = current_app.id }

  include_examples(
    "step controller",
    "param validation",
    "application required",
  )

  describe "#update" do
    context "when valid" do
      it "updates the member attributes if they are present" do
        params = {
          step: {
            members: { member.id => { employment_status: "self_employed" } },
          },
        }

        put :update, params: params

        expect(member.reload.employment_status).to eq "self_employed"
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, members: [member])
  end

  def member
    @_member ||= create(:member, employment_status: "employed")
  end
end
