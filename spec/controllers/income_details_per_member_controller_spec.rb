require "rails_helper"

RSpec.describe IncomeDetailsPerMemberController do
  let(:step) { assigns(:step) }

  before { session[:snap_application_id] = current_app.id }

  describe "#update" do
    context "when valid" do
      it "updates the member attributes if they are present" do
        params = {
          step: {
            members: {
              member.id => { self_employed_profession: "Baseball hat" },
            },
          },
        }

        put :update, params: params

        expect(member.reload.self_employed_profession).to eq "Baseball hat"
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
